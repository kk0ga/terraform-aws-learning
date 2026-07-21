variable "aws_region" {
  description = "AWS region for provider operations"
  type        = string
  default     = "ap-northeast-1"
}

variable "parameter_name" {
  description = "Fully qualified name of the production SSM parameter"
  type        = string
}

variable "parameter_value" {
  description = "Value of the production SSM parameter"
  type        = string
}