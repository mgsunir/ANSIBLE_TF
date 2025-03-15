# 1. Specify the version of the AzureRM Provider to use
terraform {
  required_version = ">=0.12"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

# az account subscription list
# az account show

provider "azurerm" {
  #features {}
  features {
    key_vault {      
    #purge_soft_delete_on_destroy = false  
    purge_soft_delete_on_destroy = false
    }
  }

  # Replace with your Azure subscription ID
  subscription_id = "088e08b8-0a3f-479a-86cc-753e92bcf726"
  # Optional: Choose the desired Azure environment from [AzureCloud, AzureChinaCloud, AzureUSGovernment, AzureGermanCloud]
  # environment = "AzureCloud"
  # Optional: Set the Azure tenant ID if using Azure Active Directory (AAD) service principal authentication
  # tenant_id = "<your_tenant_id>"
  # Optional: Set the client ID of your AAD service principal
  # client_id = "<your_client_id>"
  # Optional: Set the client secret of your AAD service principal
  # client_secret = "<your_client_secret>"
}