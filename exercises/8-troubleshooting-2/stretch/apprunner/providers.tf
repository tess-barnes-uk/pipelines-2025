terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.99"
    }
  }
}

# Configure AWS Provider
provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      Owner      = var.owner
      GithubRepo = var.repo_name
      GithubOrg  = var.org_name
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "your-own-persistent-state-bucket-name"
    key            = "p2025-apprunner-82/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    kms_key_id     = "alias/your-own-kms-key-alias-name"
    use_lockfile = true
  }
}