locals {
  home_dir    = pathexpand("~")
  username    = var.vm_username != null ? var.vm_username : basename(replace(local.home_dir, "\\", "/"))
  pubkey_file = var.vm_user_pubkey_file != null ? var.vm_user_pubkey_file : format("%s/%s", pathexpand("~/.ssh"), sort(tolist(fileset(pathexpand("~/.ssh"), "*.pub")))[0])
}
