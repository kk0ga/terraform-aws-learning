terraform {
  required_version = ">= 1.5.0"

  # bootstrap が作成した state バケット上の通常インフラ用キーを使う。
  backend "s3" {
    key          = "terraform-aws-learning/terraform.tfstate"
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