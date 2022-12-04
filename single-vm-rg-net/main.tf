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

# Create a Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.azResourceGroupName
  location = var.azLocation
}

# Create a Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.azVnetName
  address_space       = var.azVnetAddressSpace
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Create a Subnet
resource "azurerm_subnet" "main" {
  name                 = var.azSubnetName
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.azSubnetAddress
}

# Create a NIC
resource "azurerm_network_interface" "main" {
  name                = "${var.azVmName}-nic1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${var.azVmName}-ip1"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

# Create a Public IP
resource "azurerm_public_ip" "main" {
  name                = "${var.azVmName}-extip-1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Dynamic"
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                = var.azVmName
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_A1_v2"
  admin_username      = var.vmUser
  network_interface_ids = [ azurerm_network_interface.main.id ]

  admin_ssh_key {
    username   = var.vmUser
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