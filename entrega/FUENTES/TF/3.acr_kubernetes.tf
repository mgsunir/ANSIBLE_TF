
# az acr login --name terraformacruniracr1 --expose-token
# podman login -u 00000000-0000-0000-0000-000000000000 -p "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkVZSlg6Wkw3TjpRTEg3OkxMVkg6RFZZRTpFNlpPOlI0Sjc6N1Y2NDpYQUJEOlZWUkg6SVo1TjpZUlA0In0.eyJqdGkiOiI3MTNmZDMwNS1mY2UxLTQzMmEtYjNjYS1lNDkxYjFjZDUzOTAiLCJzdWIiOiJtYW51ZWwuZ3V0aWVycmV6MjE3QGNvbXVuaWRhZHVuaXIubmV0IiwibmJmIjoxNzQwNTI0MTY4LCJleHAiOjE3NDA1MzU4NjgsImlhdCI6MTc0MDUyNDE2OCwiaXNzIjoiQXp1cmUgQ29udGFpbmVyIFJlZ2lzdHJ5IiwiYXVkIjoidGVycmFmb3JtYWNydW5pcmFjcjEuYXp1cmVjci5pbyIsInZlcnNpb24iOiIxLjAiLCJyaWQiOiIxNGQ1OWMwZWU3NDA0OWNlYTIyOWUwOGQ1YjQzOWM1MiIsImdyYW50X3R5cGUiOiJyZWZyZXNoX3Rva2VuIiwiYXBwaWQiOiIwNGIwNzc5NS04ZGRiLTQ2MWEtYmJlZS0wMmY5ZTFiZjdiNDYiLCJ0ZW5hbnQiOiI4OTk3ODlkYy0yMDJmLTQ0YjQtODQ3Mi1hNmQ0MGY5ZWI0NDAiLCJwZXJtaXNzaW9ucyI6eyJhY3Rpb25zIjpbInJlYWQiLCJ3cml0ZSIsImRlbGV0ZSIsIm1ldGFkYXRhL3JlYWQiLCJtZXRhZGF0YS93cml0ZSIsImRlbGV0ZWQvcmVhZCIsImRlbGV0ZWQvcmVzdG9yZS9hY3Rpb24iXX0sInJvbGVzIjpbXX0.W9RUiNZsC4qqqkhRul6Gsd659xYN_6jbOqEg410mRvE5exEnVD6ip3gKxey_pISERKqFAnCkTr60I91z0DlXLZzBB45syx2niF5JQLQx1TuW9c1ipMfXTCugASrrM2ZUaYMvCJ-NsiGoSehICk0-u5BrxX6Dz_Zbdn34chQ_96R2f5matrc2A8bNl9EKf_jXqqZUhw5rtHlcS18r3_tcaDx96GM3sWU93uWk56rPKA8GakPL31XeOGArWLuJIZ-oBAuBRHAm5TkDEGUhm3eTi1gFUMjPSwCjKWBzqJqrQOnloCaTmw0RP11j1QBHkHcmHmQAvXg0ORPXRx61E5jsFw" terraformacruniracr1.azurecr.io

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

