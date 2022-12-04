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

resource "azurerm_public_ip" "main" {
  count               = length(var.vmSpecs)
  name                = "${var.vmSpecs[count.index].name}-pubip"
  allocation_method   = "Dynamic"
  resource_group_name = data.azurerm_resource_group.main[count.index].name
  location            = data.azurerm_resource_group.main[count.index].location
}

resource "azurerm_network_interface" "main" {
  count               = length(var.vmSpecs)
  name                = "${var.vmSpecs[count.index].name}-nic"
  resource_group_name = data.azurerm_resource_group.main[count.index].name
  location            = data.azurerm_resource_group.main[count.index].location

  ip_configuration {
    name                          = "${var.vmSpecs[count.index].name}-pubip"
    subnet_id                     = data.azurerm_subnet.main[count.index].id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vmSpecs[count.index].intIpAddr
    public_ip_address_id          = azurerm_public_ip.main[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  count                 = length(var.vmSpecs)
  name                  = var.vmSpecs[count.index].name
  resource_group_name   = data.azurerm_resource_group.main[count.index].name
  location              = data.azurerm_resource_group.main[count.index].location
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
