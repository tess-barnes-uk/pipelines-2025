# create trust policy / assume role
# beware, the role name has a max of 64 characters so ensure that the your org and repo names are short enough!
resource "aws_iam_role" "github_action_role" {
  name               = "GHAction_AssumeRole_${var.github_organisation}_${var.github_repo}"
  assume_role_policy = data.aws_iam_policy_document.github_role_policy_document.json
}

# attach permissions role custom or built in, this could be multiple policies (up to soft limit of 10 per role)
# LEAST PRIVILEGE: something smaller than admin access 
# but able to deploy all your vpc, ecr and app runner resources
# when merging, beware the "LimitExceeded: Cannot exceed quota for PolicySize: 6144"

resource "aws_iam_role_policy_attachment" "github_role_vpc" {
  role       = aws_iam_role.github_action_role.name
  policy_arn = data.aws_iam_policy.vpc_access.arn
}

data "aws_iam_policy_document" "managed" {
  source_policy_documents = [
    data.aws_iam_policy.apprunner_access.policy,
    data.aws_iam_policy.ecr_access.policy,
    data.aws_iam_policy.s3_access.policy,
    data.aws_iam_policy.secrets_access.policy
  ]
}

resource "aws_iam_policy" "managed" {
  name        = "${var.owner}-gh-managed-policy"
  description = "${var.owner}'s policy of aws managed permissions for GH Actions. Created by terraform"
  policy = data.aws_iam_policy_document.managed.json
}

resource "aws_iam_role_policy_attachment" "github_role_managed" {
  role       = aws_iam_role.github_action_role.name # helps tf understand what order to create things in
  policy_arn = aws_iam_policy.managed.arn
}

data "aws_iam_policy_document" "custom" {
  source_policy_documents = [
    data.aws_iam_policy_document.gh_iam_access.json,
    data.aws_iam_policy_document.terraform_backend_access.json
  ]
  statement {
    actions = [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion",
                "kms:RotateKeyOnDemand"
            ]
    resources = ["*"]
    effect = "Allow"
  }
  
}

resource "aws_iam_policy" "github_custom_access" {
  name        = "${var.owner}-gh-custom-policy"
  description = "${var.owner}'s restricted policy of custom iam and other permissions for GH Actions. Created by terraform"
  policy      = data.aws_iam_policy_document.custom.json
}

resource "aws_iam_role_policy_attachment" "github_role_custom" {
  role       = aws_iam_role.github_action_role.name
  policy_arn = aws_iam_policy.github_custom_access.arn
}

# Single admin policies are likely to give too many permissions
# resource "aws_iam_role_policy_attachment" "github_role_admin_policy_attach" {
#   role       = aws_iam_role.github_action_role.name
#   policy_arn = data.aws_iam_policy.admin_access_policy.arn
# }
