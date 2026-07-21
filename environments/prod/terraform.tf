terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "terraform-aws-learning-state"
    key          = "infrastructure/prod/terraform.tfstate"
    region       = "ap-northeast-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.55"
    }
  }
}