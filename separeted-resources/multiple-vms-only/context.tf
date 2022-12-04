#List with the Resource Group of each VM
data "azurerm_resource_group" "main" {
  count = length(var.vmSpecs)
  name  = var.vmSpecs[count.index].resourceGroupName
}

data "azurerm_subnet" "main" {
  count                 = length(var.vmSpecs)
  name                  = var.vmSpecs[count.index].subnetName
  virtual_network_name  = var.vmSpecs[count.index].vnetName
  resource_group_name   = var.vmSpecs[count.index].resourceGroupName
}
