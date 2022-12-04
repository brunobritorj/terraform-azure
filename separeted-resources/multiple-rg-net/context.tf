#List with the Resource Group of each Virtual Network
data "azurerm_resource_group" "main" {
  depends_on  = [ azurerm_resource_group.main ]
  count       = length(var.vnetSpecs)
  name        = var.vnetSpecs[count.index].resourceGroupName
}