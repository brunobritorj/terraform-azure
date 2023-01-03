# Fetch the Resource Group
data "azurerm_resource_group" "main" {
  name     = var.azResourceGroupName
}

# Fetch current Az account data
data "azurerm_client_config" "current" {}

# Fetch selected User to receive policy permission
data "azuread_user" "main" {
  user_principal_name = var.azKeyvaultUser
}
