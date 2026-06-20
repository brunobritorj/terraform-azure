terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = local.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = local.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = local.subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address
}

resource "azurerm_network_interface" "main" {
  name                = "${local.vm_name}-nic1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${local.vm_name}-ip1"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_public_ip" "main" {
  name                = "${local.vm_name}-extip-1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  domain_name_label   = var.vm_domain_name_label
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = local.vm_name
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = var.vm_size
  admin_username        = local.username
  network_interface_ids = [azurerm_network_interface.main.id]
  priority              = var.vm_priority

  admin_ssh_key {
    username   = local.username
    public_key = file(local.pubkey_file)
  }

  os_disk {
    caching              = "ReadOnly"
    disk_size_gb         = var.vm_disk_size_gb
    storage_account_type = "Standard_LRS"

    dynamic "diff_disk_settings" {
      for_each = var.vm_os_ephemeral ? [1] : []
      content {
        option = "Local"
      }
    }
  }

  source_image_reference {
    publisher = var.vm_image.publisher
    offer     = var.vm_image.offer
    sku       = var.vm_image.sku
    version   = var.vm_image.version
  }

  custom_data = var.cloud_init_filename != null ? filebase64(var.cloud_init_filename) : null
}
