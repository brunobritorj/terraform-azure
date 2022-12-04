variable "vmUsername" {
  description = "Username to connect to VM(s)"
  type        = string
  default     = "bruno"
}

variable "vmUserPubKeyFile" {
  description = "Path to the user public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vmSpecs" {
  description         = "Virtual Machine specifications"
  type = list(object({
    name              = string
    resourceGroupName = string
    size              = string
    vnetName          = string
    subnetName        = string
    intIpAddr         = string
  }))
  default = [

    #Define here the VM(s)
    {
      name              = "VM-DEV"
      resourceGroupName = "RG-TEST-DEV"
      size              = "Standard_A1_v2"
      vnetName          = "VNET-DEV"
      subnetName        = "Servers"
      intIpAddr         = "10.1.0.2"
    },
    #{
    #  name              = "VM-PRD"
    #  resourceGroupName = "RG-TEST-PRD"
    #  size              = "Standard_A1_v2"
    #  vnetName          = "VNET-PRD"
    #  subnetName        = "Servers"
    #  intIpAddr         = "10.2.0.2/24"
    #}

  ]
}
