output "resource_group_name" {
  value = var.gr_recursos[0]
}

output "public_ip" {
  value = azurerm_linux_virtual_machine.practica_vm.public_ip_address
}

output "namespace" {
  value = var.namespace
}


output "acr_username" {
  value = azurerm_container_registry.example.admin_username
}

output "acr_password" {
  value     = azurerm_container_registry.example.admin_password
  sensitive = true
}

output "acr_login_server" {
  value     = azurerm_container_registry.example.login_server
  sensitive = true
}


output "vm_id" {
  value = azurerm_linux_virtual_machine.practica_vm.id
}


# output "private_key" {
#   #value     = tls_private_key.ssh_key.private_key_pem
#   value     = tls_private_key.pk_private.private_key_pem
#   sensitive = true
# }

# output "public_key" {
#   #value     = tls_private_key.ssh_key.public_key_openssh
#   value     = tls_private_key.pk_private.public_key_openssh
#   sensitive = true
# }

resource "local_file" "var_acr" {
  depends_on = [ azurerm_linux_virtual_machine.practica_vm ] 
    content     = templatefile("variables_acr.tmpl",
      {
        #vm_ip = azurerm_linux_virtual_machine.practica_vm.public_ip_address
        acr_username = azurerm_container_registry.example.admin_username
        acr_password =  azurerm_container_registry.example.admin_password
        acr_login_server = azurerm_container_registry.example.login_server
      }
    )
    filename = "variables_acr.yaml"
}

resource "local_file" "var_general" {
  depends_on = [ azurerm_linux_virtual_machine.practica_vm ] 
    content     = templatefile("general.tmpl",
      {
        vm_ip = azurerm_linux_virtual_machine.practica_vm.public_ip_address
        namespace = var.namespace
        #acr_username = azurerm_container_registry.example.admin_username
        #acr_password =  azurerm_container_registry.example.admin_password
        #acr_login_server = azurerm_container_registry.example.login_server
      }
    )
    filename = "variables_general.yaml"
}

resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.example]
  content      = azurerm_kubernetes_cluster.example.kube_config_raw
  filename     =  "/home/terraform/.kube/config"
  
}
