data "aws_availability_zones" "available" {}

locals {
  name = "${var.owner}-${var.app_name}"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    AppName = local.name
  }
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = false

  tags = local.tags
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.0"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.vpc_endpoints_security_group.security_group_id]

  endpoints = {
    apprunner = {
      service = "apprunner.requests"
      # private_dns_enabled = true
      subnet_ids = module.vpc.private_subnets
      tags       = { Name = "${local.name}-apprunner" }
    },
  }

  tags = local.tags
}

module "vpc_endpoints_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${local.name}-vpc-endpoints"
  description = "Security group for VPC Endpoints"
  vpc_id      = module.vpc.vpc_id

  egress_rules       = ["https-443-tcp"]
  egress_cidr_blocks = [module.vpc.vpc_cidr_block]

  tags = local.tags
}
