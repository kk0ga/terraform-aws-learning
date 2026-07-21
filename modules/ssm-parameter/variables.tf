variable "name" {
  description = "Fully qualified name of the SSM parameter"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the SSM parameter"
  type        = map(string)
  default     = {}
}

variable "tier" {
  description = "Tier of the SSM parameter"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Advanced", "Intelligent-Tiering"], var.tier)
    error_message = "Tier must be Standard, Advanced, or Intelligent-Tiering."
  }
}

variable "type" {
  description = "Type of the SSM parameter"
  type        = string
  default     = "String"

  validation {
    condition     = contains(["String", "StringList", "SecureString"], var.type)
    error_message = "Type must be String, StringList, or SecureString."
  }
}

variable "value" {
  description = "Value to store in the SSM parameter"
  type        = string
}