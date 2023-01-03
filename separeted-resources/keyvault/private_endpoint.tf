# SECTION TO CREATE A PRIVATE ENDPOINT FOR THE KEY VAULT

# Fetch the Subnet where KVA will be attached to
data "azurerm_subnet" "main" {
  name                 = var.endpointSubnetName
  virtual_network_name = var.endpointVnetName
  resource_group_name  = data.azurerm_resource_group.main.name
}

# Create the Private Endpoint
resource "azurerm_private_endpoint" "main" {
  name                = "endpoint-${azurerm_key_vault.main.name}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  subnet_id           = data.azurerm_subnet.main.id

  private_service_connection {
    name                           = "endpoint-${azurerm_key_vault.main.name}"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection           = false
    subresource_names              = [ "vault" ]
  }
}
