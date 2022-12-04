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

# Create a Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.azResourceGroupName
  location = var.azLocation
}

# Create a Key Vault
resource "azurerm_key_vault" "main" {
  name                        = var.azKeyvaultName
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
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

resource "azurerm_key_vault_certificate" "main" {
  name         = "self-signed-cert"
  key_vault_id = azurerm_key_vault.main.id

  certificate_policy {
    issuer_parameters { name = "Self" }
    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }
    lifetime_action {
      action { action_type = "AutoRenew" }
      trigger { days_before_expiry = 30 }
    }
    secret_properties { content_type = "application/x-pkcs12" }
    x509_certificate_properties {
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"] #(Server Authentication)
      key_usage = [ "cRLSign", "dataEncipherment", "digitalSignature", "keyAgreement", "keyCertSign", "keyEncipherment" ]
      subject_alternative_names {
        dns_names = [ var.selfSignedCertDomain ]
      }
      subject            = "CN=${var.selfSignedCertDomain}"
      validity_in_months = 12
    }
  }
}