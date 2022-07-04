
variable "reg1Location" {
  description = "Location to deploy artifacts"
  type        = string
  default     = "West Europe"
}

variable "reg2Location" {
  description = "Location to deploy artifacts"
  type        = string
  default     = "North Europe"
}

variable "reg1LocationShort" {
  description = "short region naming"
  type = string
  default = "we"
}

variable "reg2LocationShort" {
  description = "short region naming"
  type = string
  default = "ne"
}

variable "ctlAdmin" {
  description = "Admin username for controler"
  type        = string
  sensitive   = true
}

variable "ctlAdminPwd" {
  description = "Admin password for controler"
  type        = string
  sensitive   = true
}

variable "ctlIP" {
  description = "IP of controler"
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