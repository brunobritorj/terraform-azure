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

# Create the Az Resource Group
resource "azurerm_resource_group" "main" {
  name      = var.resourceGroupName
  location  = var.location
}

# Create the Az Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnetSpecs.name
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [ var.vnetSpecs.addressSpace ]
  location            = azurerm_resource_group.main.location
}

resource "azurerm_subnet" "main" {
  name                 = var.vnetSpecs.subnetName
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [ var.vnetSpecs.subnetAddress ]
}

resource "azurerm_public_ip" "main" {
  count               = length(var.vmSpecs)
  name                = "${var.vmSpecs[count.index].name}-pubip"
  allocation_method   = "Dynamic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

resource "azurerm_network_interface" "main" {
  count               = length(var.vmSpecs)
  name                = "${var.vmSpecs[count.index].name}-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "${var.vmSpecs[count.index].name}-pubip"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  count                 = length(var.vmSpecs)
  name                  = var.vmSpecs[count.index].name
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = var.vmSpecs[count.index].size
  admin_username        = var.vmUsername
  network_interface_ids = [ azurerm_network_interface.main[count.index].id ]

  admin_ssh_key {
    username   = var.vmUsername
    public_key = file(var.vmUserPubKeyFile)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
