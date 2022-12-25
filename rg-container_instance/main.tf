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

resource "azurerm_container_group" "main" {
  name                = "squid-proxy"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "squid-proxy"
    image  = "ubuntu/squid:5.2-22.04_beta"
    cpu    = "0.5"
    memory = "1"

    ports {
      port     = 3128
      protocol = "TCP"
    }

  }

}