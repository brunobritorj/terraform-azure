output "ip_address" {
  depends_on  = [azurerm_linux_virtual_machine.main, azurerm_public_ip.main]
  description = "Public IPv4 address"
  value       = azurerm_public_ip.main.ip_address
}