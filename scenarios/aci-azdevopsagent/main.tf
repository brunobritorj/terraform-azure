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

# Create the Az Container Instance
resource "azurerm_container_group" "main" {
  name                = var.azContainerInstanceName
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"

  container {
    name   = "azdevops-agent"
    image  = "brunobritorj/azdevops-selfhosted:ubuntu2004-iac"
    cpu    = "1"
    memory = "1"
    environment_variables = {
      AZP_URL   = var.AZP_URL
      AZP_TOKEN = var.AZP_TOKEN
      AZP_POOL  = var.AZP_POOL
    }
    ports {
      port     = 12345
      protocol = "TCP"
    }
  }

}