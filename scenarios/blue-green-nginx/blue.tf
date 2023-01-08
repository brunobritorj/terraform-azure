# BLUE deployment

# Create the Az Public IP(s)
resource "azurerm_public_ip" "blue" {
  count               = length(var.vmSpecs)
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "${var.vmSpecs[count.index].name}-blue-pubip"

  allocation_method   = "Static"
}

# Create the Az vNIC(s)
resource "azurerm_network_interface" "blue" {
  count               = length(var.vmSpecs)
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "${var.vmSpecs[count.index].name}-blue-nic"

  ip_configuration {
    name                          = "${var.vmSpecs[count.index].name}-blue-pubip"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.blue[count.index].id
  }
}

# Create the Az Virtual Machine(s)
resource "azurerm_linux_virtual_machine" "blue" {
  count                 = length(var.vmSpecs)
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  name                  = "${var.vmSpecs[count.index].name}-blue"

  size                  = var.vmSpecs[count.index].size
  admin_username        = var.vmUsername
  network_interface_ids = [ azurerm_network_interface.blue[count.index].id ]

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

# VM-BEPool association
resource "azurerm_network_interface_backend_address_pool_association" "blue" {
  count                   = length(var.vmSpecs)
  network_interface_id    = azurerm_network_interface.blue[count.index].id
  ip_configuration_name   = "${var.vmSpecs[count.index].name}-blue-pubip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}
