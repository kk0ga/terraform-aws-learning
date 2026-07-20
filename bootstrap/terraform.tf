terraform {
  required_version = ">= 1.5.0"

  # 初回 apply 後に bootstrap 自身の state をこのキーへ移行する。
  backend "s3" {
    key          = "bootstrap/terraform.tfstate"
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