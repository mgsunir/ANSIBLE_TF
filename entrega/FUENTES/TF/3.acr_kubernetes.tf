
# az acr login --name terraformacruniracr1 --expose-token
# podman login -u 00000000-0000-0000-0000-000000000000 -p "XXXXXXXTOkken" terraformacruniracr1.azurecr.io

resource "azurerm_container_registry" "example" {
  depends_on = [
   azurerm_resource_group.recursos
    ]

  name                = var.acr_name
  resource_group_name = var.gr_recursos[0]
  location            = var.gr_recursos[1]
  sku                 = "Basic"
  admin_enabled = true
  tags = {
    Environment = "Test"
    Ceco = "UNIR"
  }
}

# az aks get-credentials --resource-group PRACTICA --name example-aks1
# Hay que ponerle depends pues sino casca por adelantarse

resource "azurerm_kubernetes_cluster" "example" {
  depends_on = [
   azurerm_resource_group.recursos
    ]

  name                = var.kubernetes_name
  location            = var.gr_recursos[1]
  resource_group_name = var.gr_recursos[0]
  dns_prefix          = var.kubernetes_name

  # https://github.com/hashicorp/terraform-provider-azurerm/issues/9604
  default_node_pool {
    vm_size    = var.default_node_pool_vm_size
    #enable_auto_scaling = var.default_node_pool_enable_auto_scaling
    enable_auto_scaling = var.default_node_pool_enable_auto_scaling
    name                = var.default_node_pool_name
    node_count          = var.default_node_pool_node_count
    #vm_size             = var.default_node_pool_vm_size
    max_pods            = var.default_node_pool_max_pods
    os_disk_size_gb     = var.default_node_pool_os_disk_size_gb
    min_count           = var.default_node_pool_min_count
    max_count           = var.default_node_pool_max_count
    type                = var.default_node_pool_type
    #vnet_subnet_id      = data.azurerm_subnet.subnet.id
    #vnet_subnet_id      = azurerm_subnet.backend.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Test"
    Ceco = "UNIR"
  }
}


resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.example.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.example.id
  skip_service_principal_aad_check = true
}

# output "passwd" {
#   value = azurerm_container_registry.example.admin_password
#   sensitive = true
# }
# output "admin" {
#   value = azurerm_container_registry.example.admin_username
# }

