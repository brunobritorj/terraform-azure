resource "random_id" "id" {
  byte_length = 2
}

locals {
  # Naming
  rg_name = var.rg_name != null ? trimspace(var.rg_name) : "rg-${random_id.id.hex}"
  vmss_name = var.vmss_name != null ? trimspace(var.vmss_name) : "vmss-${random_id.id.hex}"
  vnet_name = var.vnet_name != null ? trimspace(var.vnet_name) : "vnet-${random_id.id.hex}"
  subnet_name = var.subnet_name != null ? trimspace(var.subnet_name) : "subnet-${random_id.id.hex}"
  nsg_name = var.nsg_name != null ? trimspace(var.nsg_name) : "nsg-${random_id.id.hex}"

  # User credential
  home_dir    = pathexpand("~")
  username    = var.vmss_username != null ? trimspace(var.vmss_username) : basename(replace(local.home_dir, "\\", "/"))
  pubkey_file = var.vmss_user_pubkey_file != null ? trimspace(var.vmss_user_pubkey_file) : format("%s/%s", pathexpand("~/.ssh"), sort(tolist(fileset(pathexpand("~/.ssh"), "*.pub")))[0])
}