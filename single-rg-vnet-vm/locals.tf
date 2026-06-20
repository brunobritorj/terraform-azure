resource "random_id" "id" {
  byte_length = 2
}

locals {
  # Naming
  rg_name = var.rg_name != null ? trim(var.rg_name) : "rg-${random_id.id.hex}"
  vm_name = var.vm_name != null ? trim(var.vm_name) : "vm-${random_id.id.hex}"
  vnet_name = var.vnet_name != null ? trim(var.vnet_name) : "vnet-${random_id.id.hex}"
  subnet_name = var.subnet_name != null ? trim(var.subnet_name) : "subnet-${random_id.id.hex}"
  nsg_name = var.nsg_name != null ? trimspace(var.nsg_name) : "nsg-${random_id.id.hex}"

  # User credential
  home_dir    = pathexpand("~")
  username    = var.vm_username != null ? trim(var.vm_username) : basename(replace(local.home_dir, "\\", "/"))
  pubkey_file = var.vm_user_pubkey_file != null ? trim(var.vm_user_pubkey_file) : format("%s/%s", pathexpand("~/.ssh"), sort(tolist(fileset(pathexpand("~/.ssh"), "*.pub")))[0])
}
