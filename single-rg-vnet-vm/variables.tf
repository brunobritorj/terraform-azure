variable "azLocation" {
  type = string
  description = "Region where the Azure resources will be created"
  default = "eastus"
}

variable "azResourceGroupName" {
  type = string
  description = "Name for the Azure Resource Group"
  default = "RG-VM-TEST"
}

variable "azVnetName" {
  type = string
  default = "VNET-010-000-000-000-16"
}

variable "azVnetAddressSpace" {
  type = list
  default = ["10.0.0.0/16"]
}

variable "azSubnetName" {
  type = string
  default = "SNET-010-000-000-000-24"
}

variable "azSubnetAddress" {
  type = list
  default = ["10.0.0.0/24"]
}

variable "azVmName" {
  type = string
  description = "Name for the Azure Virtual Machine"
  default = "VM001"
}

variable "vmUser" {
  type = string
  description = "Username to access the VM"
  default = "bruno"
}

variable "vmUserPubKeyFile" {
  type = string
  description = "Location of the Public Key file"
  default = "~/.ssh/id_rsa.pub"
}