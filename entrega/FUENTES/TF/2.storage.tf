locals {
    #https://www.reddit.com/r/Terraform/comments/ysjsmh/get_value_of_string_based_on_date/
    current_time  = timestamp()
    storage_account_f =  "${formatdate("YYYYMMDDHH",local.current_time)}3"
    storage_account_n =  "${formatdate("YYYYMMDDHH",local.current_time)}"
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "diag0lab0unir0022032" {
  depends_on = [
   azurerm_resource_group.recursos
    ]

  name                     = local.storage_account_n
  location                 = var.gr_recursos[1]
  resource_group_name      = var.gr_recursos[0]
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    Environment = "Test"
    Ceco = "UNIR"
  }
}

# Create Blob container
resource "azurerm_storage_container" "terraform-container" {
name = "aa-${local.storage_account_f}-bbc"
storage_account_name = azurerm_storage_account.diag0lab0unir0022032.name
container_access_type = "private"

}

# The error message "Failed to create storage queue 'ddd'. Error: The specified queue is being deleted." indicates that there is an attempt to create a queue with the name 'ddd' while a queue with the same name is currently in the process of being deleted. In Azure Storage, when a queue is deleted, it may take some time for the deletion process to complete. During this time, the queue name is still considered in use, and you cannot create a new queue with the same name.

# To resolve this issue, you can:

# Wait for the deletion process to complete. Once the queue is fully deleted, you should be able to create a new queue with the same name.
# Use a different name for the new queue if you need to create it immediately.
# If you continue to experience issues, you may want to check the Azure portal for the status of the queue deletion or consult Azure support for further assistance.