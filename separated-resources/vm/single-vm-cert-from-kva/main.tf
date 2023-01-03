terraform {
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
  }

}

provider "azurerm" {
  features {}
}

# Get the Resource Group ID
data "azurerm_resource_group" "main" {
  name  = var.vmSpecs.resourceGroupName
}

# Get the Subnet ID
data "azurerm_subnet" "main" {
  name                  = var.vmSpecs.subnetName
  virtual_network_name  = var.vmSpecs.vnetName
  resource_group_name   = var.vmSpecs.resourceGroupName
}

# Create a Public IP
resource "azurerm_public_ip" "main" {
  name                = "${var.vmSpecs.name}-pubip"
  allocation_method   = "Dynamic"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
}

# Create a NIC to be attached to the new VM
resource "azurerm_network_interface" "main" {
  name                = "${var.vmSpecs.name}-nic"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  ip_configuration {
    name                          = "${var.vmSpecs.name}-pubip"
    subnet_id                     = data.azurerm_subnet.main.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vmSpecs.intIpAddr
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

# Get KeyVault ID
data "azurerm_key_vault" "main" {
  name                = "KVA-TEST-002"
  resource_group_name = "RG-KVA-TEST-002"
}

# Get Certificate data to be uploaded to the new VM
data "azurerm_key_vault_certificate_data" "main" {
  name         = "self-signed-cert"
  key_vault_id = data.azurerm_key_vault.main.id
}

# Create a Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                  = var.vmSpecs.name
  resource_group_name   = data.azurerm_resource_group.main.name
  location              = data.azurerm_resource_group.main.location
  size                  = var.vmSpecs.size
  admin_username        = var.vmUsername
  network_interface_ids = [ azurerm_network_interface.main.id ]

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

  provisioner "file" {
    content = "XXX"
    destination = "/tmp/xxx.txt"
    connection {
      type     = "ssh"
      user     = "bruno"
      host     = azurerm_linux_virtual_machine.main.public_ip_addresses
    }
  }

  #provisioner "file" {
  #  content = data.azurerm_key_vault_certificate_data.main.pem
  #  destination = "/etc/ssl/${data.azurerm_key_vault_certificate_data.main.name}.pem"
  #}

  #provisioner "file" {
  #  content = data.azurerm_key_vault_certificate_data.main.key
  #  destination = "/etc/ssl/private/${data.azurerm_key_vault_certificate_data.main.name}.key"
  #}

}
