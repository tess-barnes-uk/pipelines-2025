# reference: https://github.com/terraform-aws-modules/terraform-aws-app-runner/blob/v1.2.1/examples/complete/main.tf

locals {
  name = "${var.owner}-${var.app_name}"

  tags = {
    AppName = local.name
  }
}

data "aws_vpc" "connected" {
  filter {
    name   = "tag:AppName"
    values = [local.name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.connected.id]
  }

  tags = {
    Tier = "Private"
  }
}

data "aws_subnet" "private_list" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_ecr_repository" "private" {
  name = "${var.owner}_${var.ecr_repository}"
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "Security group for AppRunner connector"
  vpc_id      = data.aws_vpc.connected.id

  egress_rules       = ["http-80-tcp"]
  egress_cidr_blocks = compact([for s in data.aws_subnet.private_list : s.cidr_block])

  tags = local.tags
}


################################################################################
# App Runner Module - using the image based approach
################################################################################

module "app_runner_shared_configs" {
  source  = "terraform-aws-modules/app-runner/aws"
  version = "1.2.1"

  # Disable service resources
  create_service = false

  auto_scaling_configurations = {
    mini = {
      name            = "mini"
      max_concurrency = 20
      max_size        = 2
      min_size        = 1

      tags = {
        Type = "Mini"
      }
    }

    mega = { //not actually going to use this, but it's a high volume production example, beware costs
      name            = "mega"
      max_concurrency = 200
      max_size        = 25
      min_size        = 5

      tags = {
        Type = "MEGA"
      }
    }
  }

  tags = local.tags
}

# can we set this up to trigger a redeploy automatically on ecr image change?
module "app_runner_image_base" {
  source  = "terraform-aws-modules/app-runner/aws"
  version = "1.2.1"

  service_name = "${local.name}-svc"

  # Pulling from shared configs
  auto_scaling_configuration_arn = module.app_runner_shared_configs.auto_scaling_configurations["mini"].arn

  # IAM instance profile permissions to access secrets
  instance_policy_statements = {
    GetSecretValue = {
      actions   = ["secretsmanager:GetSecretValue"]
      resources = [aws_secretsmanager_secret.this.arn]
    }
  }

  source_configuration = {
    authentication_configuration = {
      access_role_arn = aws_iam_role.app_runner_ecr_access_role.arn
    }
    auto_deployments_enabled = true # ensures that a new image sha will trigger a redeployment (only works for ecr images in the same account)
    image_repository = {
      image_configuration = {
        port = var.app_port
        runtime_environment_variables = {
          MY_VARIABLE = "hello!"
        }
        runtime_environment_secrets = {
          MY_SECRET = aws_secretsmanager_secret.this.arn
        }
      }
      # image_identifier      = "public.ecr.aws/aws-containers/hello-app-runner:latest"
      # image_repository_type = "ECR_PUBLIC"
      image_identifier      = "${data.aws_ecr_repository.private.repository_url}:${var.fixed_image_tag}"
      image_repository_type = "ECR"

    }
  }

  # # Requires manual intervention to validate records - we will ignore custom domains for this course
  # # https://github.com/hashicorp/terraform-provider-aws/issues/23460
  # create_custom_domain_association = true
  # hosted_zone_id                   = "<TODO>"
  # domain_name                      = "<TODO>"
  # enable_www_subdomain             = true

  create_vpc_connector          = true
  vpc_connector_subnets         = data.aws_subnets.private.ids
  vpc_connector_security_groups = [module.security_group.security_group_id]
  network_configuration = {
    egress_configuration = {
      egress_type = "VPC"
    }
  }

  enable_observability_configuration = false # we get log groups anyway, this is just for AWS XRAY tracing

  tags = local.tags
}


resource "aws_secretsmanager_secret" "this" {
  name_prefix             = local.name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = "example"
}

resource "aws_iam_role" "app_runner_ecr_access_role" {
  name = "${var.role_prefix}ARECRAccessRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "build.apprunner.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app_runner_ecr_access_role_policy_attachment" {
  role       = aws_iam_role.app_runner_ecr_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

