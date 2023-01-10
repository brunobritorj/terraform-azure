variable "location" {
  description = "Region where the Azure resources will be created"
  type        = string
  default     = "eastus"
}

variable "resourceGroupName" {
  description = "Resource Group to be created"
  type        = string
  default     = "RG-ACI-AzDevopsAgent"
}

variable "azContainerInstanceName" {
  description = "ACI to be created"
  type        = string
  default     = "aci-azdevopsagent"
}

variable "AZP_URL" {
  description = "The Azure DevOps Organization URL"
  type        = string
}

variable "AZP_TOKEN" {
  description = "Personal Access Token (PAT)"
  type        = string
}

variable "AZP_POOL" {
  description = "Agent Pool name"
  type        = string
  default     = "Default"
}
