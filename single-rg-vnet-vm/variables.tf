variable "location" {
  type        = string
  description = "Region where the Azure resources will be created"
  default     = "eastus"
}

variable "rg_name" {
  type        = string
  description = "Name for the Azure Resource Group"
  default     = "RG-VM-TEST"
}

variable "vnet_name" {
  type    = string
  default = "VNET-010-000-000-000-16"
}

variable "vnet_address_space" {
  type    = list(any)
  default = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type    = string
  default = "SNET-010-000-000-000-24"
}

variable "subnet_address" {
  type    = list(any)
  default = ["10.0.0.0/24"]
}

variable "vm_name" {
  type        = string
  description = "Name for the Azure Virtual Machine"
  default     = "VM001"
}

variable "vm_size" {
  type        = string
  description = "Size of the Azure Virtual Machine"
  default     = "Standard_B1ls"
}

variable "vm_cost_profile" {
  type = object({
    priority          = optional(string, "Spot")
    eviction_policy   = optional(string, "Delete")
    max_bid_price     = optional(string, -1)
    os_disk_ephemeral = optional(bool, true)
  })
  default = {
    priority          = "Spot"
    eviction_policy   = "Delete"
    max_bid_price     = -1
    os_disk_ephemeral = true
  }
}

variable "vm_image" {
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

variable "vm_username" {
  type        = string
  description = "Username to access the VM"
  default     = null
}

variable "vm_user_pubkey_file" {
  type        = string
  description = "Location of the Public Key file"
  default     = null
}

variable "cloud_init_filename" {
  type        = string
  description = "Path for a cloud-init.yaml file"
  default     = null
}

variable "vm_domain_name_label" {
  type        = string
  description = "DNS entry"
  default     = null
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
