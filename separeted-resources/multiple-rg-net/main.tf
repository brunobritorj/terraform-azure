terraform {
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

}

provider "azurerm" {
  features {}
}

# Create the Az Resource Group(s)
resource "azurerm_resource_group" "main" {
  count     = length(var.resourceGroupSpecs)
  name      = var.resourceGroupSpecs[count.index].name
  location  = var.resourceGroupSpecs[count.index].location
}

# List with the Resource Group of each Virtual Network
data "azurerm_resource_group" "main" {
  depends_on  = [ azurerm_resource_group.main ]
  count       = length(var.vnetSpecs)
  name        = var.vnetSpecs[count.index].resourceGroupName
}

# Create the Az Virtual Network(s)
resource "azurerm_virtual_network" "main" {
  count               = length(var.vnetSpecs)
  name                = var.vnetSpecs[count.index].name
  resource_group_name = var.vnetSpecs[count.index].resourceGroupName
  address_space       = [ var.vnetSpecs[count.index].addressSpace ]
  location            = data.azurerm_resource_group.main[count.index].location
}

# Create the Az Virtual Subnet(s)
resource "azurerm_subnet" "main" {
  count                 = length(var.vnetSpecs)
  name                  = var.vnetSpecs[count.index].subnetName
  resource_group_name   = azurerm_resource_group.main[count.index].name
  virtual_network_name  = azurerm_virtual_network.main[count.index].name
  address_prefixes      = [ var.vnetSpecs[count.index].subnetAddress ]
}
