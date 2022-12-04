# terraform-azure-vm

Clone it, choose one flavor (folder), and run local!

1. Make sure you are authenticated in Azure (```az login```).
2. Go to any folder you wish inside the ```src``` directory.
3. For most of the Linux VM deployments, make sure you have generated a public key in your client computer.
4. Run it (```terraform init``` / ```terraform plan``` / ```terraform apply```)

You may feed plan/apply with vars instead the default ones, take a look at the options in the associated ```variables.tf``` file.
