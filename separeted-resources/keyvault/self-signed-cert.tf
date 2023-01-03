# SECTION TO CREATE A SELF-SIGNED CERTIFICATE IN THE KEY VAULT

## Create a self-signed certificate
#resource "azurerm_key_vault_certificate" "main" {
#  name         = "self-signed-cert"
#  key_vault_id = azurerm_key_vault.main.id
#
#  certificate_policy {
#    issuer_parameters { name = "Self" }
#    key_properties {
#      exportable = true
#      key_size   = 2048
#      key_type   = "RSA"
#      reuse_key  = true
#    }
#    lifetime_action {
#      action { action_type = "AutoRenew" }
#      trigger { days_before_expiry = 30 }
#    }
#    secret_properties { content_type = "application/x-pkcs12" }
#    x509_certificate_properties {
#      extended_key_usage = ["1.3.6.1.5.5.7.3.1"] #(Server Authentication)
#      key_usage = [ "cRLSign", "dataEncipherment", "digitalSignature", "keyAgreement", "keyCertSign", "keyEncipherment" ]
#      subject_alternative_names {
#        dns_names = [ var.selfSignedCertDomain ]
#      }
#      subject            = "CN=${var.selfSignedCertDomain}"
#      validity_in_months = 12
#    }
#  }
#}
