variable "azResourceGroupName" {
  type = string
  description = "Name for the EXISTING Az Resource Group"
  default = "RG-TEST-DEV"
}

variable "azKeyvaultName" {
  type = string
  default = "KVA-TEST-001"
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

variable "endpointVnetName" {
  type = string
  description = "Name for the EXISTING Az Virtual Network IF it going to create a private endpoint"
  default = "VNET-DEV"
}

variable "endpointSubnetName" {
  type = string
  description = "Name for the EXISTING Az Subnet IF it going to create a private endpoint"
  default = "Servers"
}
