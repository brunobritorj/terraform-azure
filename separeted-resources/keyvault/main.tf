terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "2.31.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Fetch the Resource Group
data "azurerm_resource_group" "main" {
  name     = var.azResourceGroupName
}

# Create the Key Vault
resource "azurerm_key_vault" "main" {
  name                        = var.azKeyvaultName
  location                    = data.azurerm_resource_group.main.location
  resource_group_name         = data.azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azuread_user.main.object_id
    certificate_permissions = [
      "Create", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import",
      "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update",
    ]
    key_permissions = [
      "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List",
      "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey",
    ]
    secret_permissions = [ "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set" ]
  }

}
