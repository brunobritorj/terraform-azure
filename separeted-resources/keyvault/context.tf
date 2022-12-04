# Current Az account data
data "azurerm_client_config" "current" {}

# Selected User to receive policy permission
data "azuread_user" "main" {
  user_principal_name = var.azKeyvaultUser
}