terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.55"
    }
  }
}

variable "aws_region" {
  description = "AWS region for provider operations"
  type        = string
}

provider "aws" {
  region = var.aws_region
}

resource "aws_ssm_parameter" "example" {
  name  = "/sandbox/example-message"
  type  = "String"
  value = "hello-from-terraform"
  tier  = "Standard"
}