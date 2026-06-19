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

resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name                = local.vmss_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.vmss_size
  priority            = var.vmss_priority
  instances           = 1

  admin_username = local.username

  admin_ssh_key {
    username   = local.username
    public_key = file(local.pubkey_file)
  }

  source_image_reference {
    publisher = var.vmss_image.publisher
    offer     = var.vmss_image.offer
    sku       = var.vmss_image.sku
    version   = var.vmss_image.version
  }

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"

    dynamic diff_disk_settings {
      for_each = var.vm_os_ephemeral ? [1] : []
      content {
        option = "Local"
      }
    }
  }

  network_interface {
    name    = "${local.vmss_name}-nic"
    primary = true

    ip_configuration {
      name      = "${local.vmss_name}-ip"
      primary   = true
      subnet_id = azurerm_subnet.main.id

      public_ip_address {
        name                    = "${local.vmss_name}-pip"
        domain_name_label       = var.vmss_dns_label
        idle_timeout_in_minutes = 4
      }
    }
  }

  custom_data = var.vmss_cloud_init_filename != null ? filebase64(var.vmss_cloud_init_filename) : null

  depends_on = [
    azurerm_subnet.main
  ]
}
