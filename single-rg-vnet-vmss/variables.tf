variable "location" {
  type        = string
  description = "Region where the Azure resources will be created"
  default     = "eastus"
}

variable "rg_name" {
  type        = string
  description = "Name for the Azure Resource Group"
  default     = null
}

variable "vnet_name" {
  type    = string
  default = null
}

variable "vnet_address_space" {
  type    = list(any)
  default = ["192.168.0.0/16"]
}

variable "subnet_name" {
  type    = string
  default = null
}

variable "subnet_address" {
  type    = list(any)
  default = ["192.168.0.0/24"]
}

variable "vmss_name" {
  type        = string
  description = "Name for the Azure Virtual Machine ScaleSet"
  default     = null
}

variable "vmss_size" {
  type        = string
  description = "Size of the Azure Virtual Machine ScaleSet"
  default     = "Standard_B1s"
}

variable "vmss_instances" {
  type        = number
  description = "Number of VMs in the Azure Virtual Machine ScaleSet"
  default     = 1
}

variable "vmss_priority" {
  type        = string
  description = "Whether VMSS instances are Regular or Spot instances"
  default     = "Regular"
}

variable "vm_os_ephemeral" {
  type        = bool
  description = "Wheter OS disk should be ephemeral or not"
  default     = false
}

variable "vmss_image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = optional(string, "latest")
  })
  description = "Image for the Azure Virtual Machine"
  default = {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
  }
}

variable "vmss_username" {
  type        = string
  description = "Username to access the VM"
  default     = null
}

variable "vmss_user_pubkey_file" {
  type        = string
  description = "Location of the Public Key file"
  default     = null
}

variable "vmss_cloud_init_filename" {
  type        = string
  description = "Path for a cloud-init.yaml file"
  default     = null
}

variable "vmss_dns_label" {
  type        = string
  description = "Prefix to be used for the Domain Name Label"
  default     = null
}

variable "nsg_name" {
  type    = string
  default = null
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
  default = [
    {
      name                   = "ssh"
      priority               = 100
      destination_port_range = 22
    }
  ]
}
