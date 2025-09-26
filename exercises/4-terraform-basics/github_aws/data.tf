data "aws_iam_policy" "secrets_access" {
  name = "SecretsManagerReadWrite"
}

data "aws_iam_policy" "apprunner_access" {
  name = "AWSAppRunnerFullAccess"
}

data "aws_iam_policy" "vpc_access" {
  name = "AmazonVPCFullAccess"
}

data "aws_iam_policy" "ecr_access" {
  name = "AmazonEC2ContainerRegistryFullAccess"
}

data "aws_iam_policy" "s3_access" {
  name = "AmazonS3FullAccess"
}

# data "aws_iam_policy" "admin_access_policy" {
#   name = var.policy_name
# }