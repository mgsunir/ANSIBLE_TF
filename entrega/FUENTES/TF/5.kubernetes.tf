
provider "kubernetes" {
  config_path = "~/.kube/config"  # Path to your kubeconfig file
}

# genero secreto via data con formato json
resource "kubernetes_secret" "podmansec" {
  metadata {
    name = "podmansec"
    namespace = var.namespace_terraform    
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${azurerm_container_registry.example.login_server}" = {
          "username" = "${azurerm_container_registry.example.admin_username}"
          "password" = "${azurerm_container_registry.example.admin_password}"
          "email"    = "${azurerm_container_registry.example.admin_username}@kk.es"
          "auth"     = base64encode("${azurerm_container_registry.example.admin_username}:${azurerm_container_registry.example.admin_password}")
        }
      }
    })
  }
}

# Create a Kubernetes namespace
# az aks get-credentials --name
#                        --resource-group
#                        [--admin]
#                        [--context]
#                        [--file]
#                        [--format]
#                        [--overwrite-existing]
#                        [--public-fqdn]
# https://thomasthornton.cloud/2023/02/22/deploy-container-app-and-pull-image-from-azure-container-registry-using-terraform/

# Creo namespace
resource "kubernetes_namespace" "k8s_ns" {
    depends_on = [ 
    azurerm_kubernetes_cluster.example
    ]
  metadata {
    annotations = {
      name = var.namespace_terraform
    }

    labels = {
      nslabel = var.namespace_terraform
    }

    name = var.namespace_terraform
  }
}
# Create a Kubernetes deployment with PVC
resource "kubernetes_deployment" "nginx_deployment" {
depends_on = [ 
    kubernetes_secret.podmansec
    ]
  metadata {
    name = "nginx-deploy"
    namespace = var.namespace_terraform    
    labels = {
      app = "app-nginx"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "app-nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-nginx"
        }
      }
      spec {
        container {
          name =  split(":", var.acr_images[0])[0]             
          command = [ "/bin/sh" ,"-c", "while true; do echo $(date) >> /mnt/azuredisk/outfile; sleep 1; done" ]
          image = "${azurerm_container_registry.example.login_server}/${var.acr_images[0]}_Z" 
          # Other container configurations as needed
           volume_mount {
             mount_path = "/mnt/azuredisk"
             name = "azuredisk01"
           }                    
        }
      image_pull_secrets {
        name = kubernetes_secret.podmansec.metadata.0.name
      }


      volume {
        name = "azuredisk01"        
        persistent_volume_claim {
          # claim_name = "${kubernetes_persistent_volume_claim.pvc-nginx.metadata.0.name}"
          claim_name = "pvc-nginx"        
        }
      }
            }
    }
  }
}

# Second deployment pulling same pvc, and generates second PV
resource "kubernetes_deployment" "nginx_deployment1" {
depends_on = [ 
    kubernetes_secret.podmansec
    ]
  metadata {
    name = "nginx-deploy1"
    namespace = var.namespace_terraform    
    labels = {
      app = "app-nginx1"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "app-nginx1"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-nginx1"
        }
      }
      spec {
        container {
          name =  split(":", var.acr_images[0])[0]   
          image = "${azurerm_container_registry.example.login_server}/${var.acr_images[0]}_Z" 
          command = [ "/bin/sh" ,"-c", "while true; do echo $(date) >> /mnt/azuredisk/outfile; sleep 1; done" ]

          #image = "nginx"
          # Other container configurations as needed
           volume_mount {
             mount_path = "/mnt/azuredisk1"
             name = "azuredisk01"
           }                    
        }
      image_pull_secrets {
        name = kubernetes_secret.podmansec.metadata.0.name
      }

      volume {
        name = "azuredisk01"        
        persistent_volume_claim {
          # claim_name = "${kubernetes_persistent_volume_claim.pvc-nginx.metadata.0.name}"
          claim_name = "pvc-nginx"        
        }
      }
      

      }
    }
  }
}

# Third

# Third deployment pulling same pvc, and generates second PV
# resource "kubernetes_deployment" "nginx_deployment2" {
# depends_on = [ 
#     kubernetes_secret.podmansec
#     ]
#   metadata {
#     name = "nginx-deploy2"
#     namespace = var.namespace_terraform    
#     labels = {
#       app = "app-nginx2"
#     }

#   }

#   spec {
#     replicas = 1
#     selector {
#       match_labels = {
#         app = "app-nginx2"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "app-nginx2"
#         }
#       }
#       spec {
#         container {
#           name =  split(":", var.acr_images[0])[0]   
#           image = "${azurerm_container_registry.example.login_server}/${var.acr_images[0]}_Z" 
#           command = [ "/bin/sh" ,"-c", "while true; do echo $(date) >> /mnt/azuredisk/outfile; sleep 1; done" ]

#           #image = "nginx"
#           # Other container configurations as needed
#            volume_mount {
#              mount_path = "/mnt/azuredisk2"
#              name = "azuredisk01"
#            }                    
#         }
#       image_pull_secrets {
#         name = kubernetes_secret.podmansec.metadata.0.name
#       }

#       volume {
#         name = "azuredisk01"        
#         persistent_volume_claim {
#           # claim_name = "${kubernetes_persistent_volume_claim.pvc-nginx.metadata.0.name}"
#           #claim_name = "pvc-nginx"        
#         }
#       }
      

#       }
#     }
#   }
# }

# Create a Kubernetes service
resource "kubernetes_service" "nginx_service" {
  depends_on = [ 
    kubernetes_namespace.k8s_ns
    ]
  metadata {
    name = "nginx-service"
    namespace = var.namespace_terraform
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "app-nginx"      
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

# 
## /subscriptions/088e08b8-0a3f-479a-86cc-753e92bcf726/resourceGroups/main_resources/providers/Microsoft.Compute/disks/myAKSDisk
 resource "azurerm_managed_disk" "pvrmdisk" {
   name                 = "pvrmdisk"
   location              = var.gr_recursos[1]
   resource_group_name   = var.gr_recursos[0]
   storage_account_type = "Standard_LRS"
   create_option        = "Empty"
   disk_size_gb         = "1"
   tags = {
     environment = "MC_${azurerm_resource_group.recursos.name}_${azurerm_kubernetes_cluster.example.name}_westeurope"      
   }
 }

resource "kubernetes_persistent_volume_v1" "pv-nginx" {
    depends_on = [ 
    azurerm_managed_disk.pvrmdisk
    ]

  metadata {
    name = "pv-nginx"    
  }
  spec {       
    capacity = {
      storage = "1Gi"
    }
    storage_class_name = "standard"
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      azure_disk {
        caching_mode  = "None"
        data_disk_uri = azurerm_managed_disk.pvrmdisk.id
        disk_name     = "pvrmdisk"
        kind          = "Managed"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "pvc-nginx" {
     depends_on = [ 
     kubernetes_namespace.k8s_ns
     ]
   metadata {
     name = "pvc-nginx"
     namespace = var.namespace_terraform
   }
   spec {
     storage_class_name = "managed-csi"
     access_modes = ["ReadWriteMany"]
     resources {
       requests = {
         storage = "1Gi"
       }
     }    
     volume_name = "${kubernetes_persistent_volume_v1.pv-nginx.metadata.0.name}"
   }
 }



# #
# # https://stackoverflow.com/questions/68580196/how-to-push-a-docker-image-to-azure-container-registry-using-terraform
#
# https://learn.microsoft.com/en-us/azure/aks/azure-csi-blob-storage-provision?tabs=mount-blobfuse%2Csecret
# https://stackoverflow.com/questions/62614458/permissions-error-when-attaching-azure-disk-to-aks-pod
# ESTA VA PARA PV y PVCS
# https://learn.microsoft.com/en-us/azure/aks/azure-csi-blob-storage-provision?tabs=mount-nfs%2Csecret
# https://learn.microsoft.com/en-us/azure/aks/azure-disk-csi
# Events:
#   Type     Reason              Age                From                     Message
#   ----     ------              ----               ----                     -------
#   Normal   Scheduled           32s                default-scheduler        Successfully assigned from-terraform/nginx-deploy-8d4bff889-mvzwv to aks-poolmin-84791672-vmss000000
#   Warning  FailedAttachVolume  14s (x6 over 32s)  attachdetach-controller  AttachVolume.Attach failed for volume "pv-nginx" : rpc error: code = NotFound desc = Volume not found, failed with error: GET http://localhost:7788/subscriptions/088e08b8-0a3f-479a-86cc-753e92bcf726/resourceGroups/main_resources/providers/Microsoft.Compute/disks/pvrmdisk
# --------------------------------------------------------------------------------
# RESPONSE 403: 403 Forbidden
# ERROR CODE: AuthorizationFailed
# --------------------------------------------------------------------------------
# {
#   "error": {
#     "code": "AuthorizationFailed",
#     "message": "The client '3847ede8-09ce-4929-989b-039717987e72' with object id '3847ede8-09ce-4929-989b-039717987e72' does not have authorization to perform action 'Microsoft.Compute/disks/read' over scope '/subscriptions/088e08b8-0a3f-479a-86cc-753e92bcf726/resourceGroups/main_resources/providers/Microsoft.Compute/disks/pvrmdisk' or the scope is invalid. If access was recently granted, please refresh your credentials."
#   }
# }
# ------------

