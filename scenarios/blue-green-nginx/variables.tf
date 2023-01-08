variable "location" {
  description = "Region where the Azure resources will be created"
  type        = string
  default     = "eastus"
}

variable "resourceGroupName" {
  description = "Resource Group to be created"
  type        = string
  default     = "RG-NGINX-BlueGreen"
}

variable "vnetSpecs" {
  description         = "Virtual Network(s) specifications to be created"
  type = object({
    name              = string
    addressSpace      = string
    subnetName        = string
    subnetAddress     = string
  })
  default = {
    name              = "VNET-NGINX"
    addressSpace      = "10.0.0.0/16"
    subnetName        = "SNET-10-24"
    subnetAddress     = "10.0.0.0/24"
  }
}

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
    name  = string
    size  = string
  }))
  default = [

    #Define here the VM(s)
    {
      name              = "VM001"
      size              = "Standard_A1_v2"
    }#,
    #{
    #  name              = "VM002"
    #  size              = "Standard_A1_v2"
    #}
  
  ]
}
