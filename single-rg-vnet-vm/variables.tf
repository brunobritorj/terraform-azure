variable "az_location" {
  type        = string
  description = "Region where the Azure resources will be created"
  default     = "eastus"
}

variable "az_resource_group_name" {
  type        = string
  description = "Name for the Azure Resource Group"
  default     = "RG-VM-TEST"
}

variable "az_vnet_name" {
  type    = string
  default = "VNET-010-000-000-000-16"
}

variable "az_vnet_address_space" {
  type    = list
  default = ["10.0.0.0/16"]
}

variable "az_subnet_name" {
  type    = string
  default = "SNET-010-000-000-000-24"
}

variable "az_subnet_address" {
  type    = list
  default = ["10.0.0.0/24"]
}

variable "az_vm_name" {
  type        = string
  description = "Name for the Azure Virtual Machine"
  default     = "VM001"
}

variable "az_vm_size" {
  type        = string
  description = "Size of the Azure Virtual Machine"
  default     = "Standard_A1_v2"
}

variable "az_vm_image" {
  type        = object({
    publisher = string
    offer     = string
    sku       = string
    version   = optional(string, "latest")
  })
  description = "Image for the Azure Virtual Machine"
  default     = {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
  }
}

variable "vm_user" {
  type        = string
  description = "Username to access the VM"
  default     = "bruno"
}

variable "vm_user_pub_key_file" {
  type        = string
  description = "Location of the Public Key file"
  default     = "~/.ssh/id_rsa.pub"
}

variable "nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = optional(string, "Inbound")
    access                     = optional(string, "Allow")
    protocol                   = optional(string, "Tcp")
    source_port_range          = optional(string, "*")
    destination_port_range     = string
    source_address_prefix      = optional(string, "*")
    destination_address_prefix = optional(string, "*")
  }))
  default = []
}