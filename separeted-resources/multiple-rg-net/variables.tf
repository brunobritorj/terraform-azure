variable "resourceGroupSpecs" {
  description         = "Resource Group(s) specifications to be created"
  type = list(object({
    name      = string
    location  = string
  }))
  default = [

    {
      name      = "RG-TEST-DEV"
      location  = "eastus"
    },
    #{
    #  name      = "RG-TEST-PRD"
    #  location  = "eastus"
    #}

  ]
}

variable "vnetSpecs" {
  description         = "Virtual Network(s) specifications to be created"
  type = list(object({
    name              = string
    resourceGroupName = string
    addressSpace      = string
    subnetName        = string
    subnetAddress     = string
  }))
  default = [
    
    {
      name              = "VNET-DEV"
      resourceGroupName = "RG-TEST-DEV"
      addressSpace      = "10.1.0.0/16"
      subnetName        = "Servers"
      subnetAddress     = "10.1.0.0/24"
    },
    #{
    #  name              = "VNET-PRD"
    #  resourceGroupName = "RG-TEST-PRD"
    #  addressSpace      = "10.2.0.0/16"
    #  subnetName        = "Servers"
    #  subnetAddress     = "10.2.0.0/24"
    #}
    
  ]
}
