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

# Create the Az Subnet
resource "azurerm_subnet" "main" {
  name                 = var.vnetSpecs.subnetName
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [ var.vnetSpecs.subnetAddress ]
}

# Create Az Public IP for LoadBalancer
resource "azurerm_public_ip" "ilb" {
  name                = "PublicIPForLB"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

# Create Az Load Balancer, BEPool, Probe, and Rule
resource "azurerm_lb" "main" {
  name                = "TestLoadBalancer"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  frontend_ip_configuration {
    name                 = "defaultSite"
    public_ip_address_id = azurerm_public_ip.ilb.id
  }

}
resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "backend-pool"
}
resource "azurerm_lb_probe" "http" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "http"

  port                = 80
}
resource "azurerm_lb_rule" "main" {
  resource_group_name             = azurerm_resource_group.main.name
  loadbalancer_id                 = azurerm_lb.main.id
  name                            = "http"

  frontend_ip_configuration_name  = "defaultSite"
  protocol                        = "Tcp"
  frontend_port                   = 80
  backend_port                    = 80
  backend_address_pool_id         = azurerm_lb_backend_address_pool.main.id
  probe_id                        = azurerm_lb_probe.http.id
}
