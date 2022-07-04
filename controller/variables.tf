variable "ctlAdminPwd" {
  description = "Admin password for controler"
  type        = string
  sensitive   = true
}

variable "avxLicenseId" {
  description = "License ID"
  type        = string
  sensitive   = true
}

variable "avx_controller_admin_email" {
  description = "Admin email"
  type        = string
}

variable "avx_account_email" {
  description = "Account email"
  type        = string
}