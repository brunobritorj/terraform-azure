variable "azLocation" {
  type = string
  description = "Region where the Azure resources will be created"
  default = "brazilsouth"
}

variable "azResourceGroupName" {
  type = string
  description = "Name for the Azure Resource Group"
  default = "RG-ACI-SquidProxy"
}
