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
  type = object({
    name              = string
    resourceGroupName = string
    size              = string
    vnetName          = string
    subnetName        = string
    intIpAddr         = string
  })
  default = {
    name              = "VM-DEV"
    resourceGroupName = "RG-TEST-DEV"
    size              = "Standard_A1_v2"
    vnetName          = "VNET-DEV"
    subnetName        = "Servers"
    intIpAddr         = "10.1.0.11"
  }
}
