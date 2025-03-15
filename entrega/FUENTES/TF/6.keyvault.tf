data "azurerm_client_config" "current" {
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

locals {
    current_time_v  = timestamp()
    key_vault_seq =  "${formatdate("YYYYMMDDHHMM",local.current_time_v)}"
}

resource "azurerm_key_vault" "terra_vault17" {
  depends_on = [
   azurerm_resource_group.recursos
  ]
  name = "kv${local.key_vault_seq}"
  location = var.gr_recursos[1]
  resource_group_name = var.gr_recursos[0]
  #tenant_id = data.azurerm_client_config.current.tenant_id
  tenant_id =  data.azurerm_client_config.current.tenant_id
  sku_name = "standard"
# https://stackoverflow.com/questions/77130498/azurerm-need-2-shots-to-destroy-an-azure-key-vault
  purge_protection_enabled   = false
#soft_delete_retention_days = 7

# https://stackoverflow.com/questions/57111391/terraform-azure-keyvault-setsecret-forbidden-access-denied

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${data.azurerm_client_config.current.object_id}"
    application_id = "${data.azurerm_client_config.current.client_id}"

    key_permissions         = [ "Get","List","Update","Create","Import","Delete","Recover","Backup","Restore"]
    secret_permissions      = [ "Get","List","Delete","Recover","Backup","Restore","Set","Purge"     ]
    certificate_permissions = [ "Get","List","Update","Create","Import","Delete","Recover","Backup","Restore", "DeleteIssuers", "GetIssuers", "ListIssuers", "ManageContacts", "ManageIssuers", "SetIssuers"]
  }

tags = {
    Environment = "Test"
    Ceco = "UNIR"
  }
}

# az keyvault secret list --vault-name terraform-keyvault14
# az keyvault secret list --vault-name terraform-keyvault15
# az keyvault secret show --name example-secret --vault-name terraform-keyvault12


# https://lepczynski.it/en/azure_en/azure-keyvault-permanently-delete-a-secret/
resource "azurerm_key_vault_secret" "terra_secret48" {
name = "kvs${local.key_vault_seq}"
value = "Su PM con el purge de los secretos"

key_vault_id = azurerm_key_vault.terra_vault17.id
tags = {
    Environment = "Test"
    Ceco = "UNIR"
  }
}
