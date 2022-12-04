variable "azLocation" {
  type = string
  description = "Region where the Azure resources will be created"
  default = "eastus"
}

variable "azResourceGroupName" {
  type = string
  description = "Name for the Azure Resource Group"
  default = "RG-KVA-TEST-002"
}

variable "azKeyvaultName" {
  type = string
  default = "KVA-TEST-002"
}

variable "azKeyvaultUser" {
  type = string
  description = "User to receive initial policy permission"
  default = "brunobritorj@brunobritorjoutlook.onmicrosoft.com"
}

variable "selfSignedCertDomain" {
  type = string
  description = "Domain to generate a self signed certiticate"
  default = "example.com"
}
