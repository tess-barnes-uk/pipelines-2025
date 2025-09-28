terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.99"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

# Configure AWS Provider
provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      Owner      = var.owner
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "your-own-persistent-state-bucket-name"
    key            = "p2025-deploy-81/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    kms_key_id     = "alias/your-own-kms-key-alias-name"
    use_lockfile = true
  }
}