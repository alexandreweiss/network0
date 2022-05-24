
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