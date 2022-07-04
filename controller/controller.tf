terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
    features {
    }
}

module "aviatrix_controller_azure" {
   source                        = "AviatrixSystems/azure-controller/aviatrix"
   controller_name               = "avx-ctl"
   // Example incoming_ssl_cidr list: ["1.1.1.1/32","10.10.0.0/16"]
   incoming_ssl_cidr             = ["86.192.227.204/32"]
   avx_controller_admin_email    = var.avx_controller_admin_email
   avx_controller_admin_password = var.ctlAdminPwd
   account_email                 = var.avx_account_email
   access_account_name           = "alweiss-internal"
   aviatrix_customer_id          = var.avxLicenseId
}