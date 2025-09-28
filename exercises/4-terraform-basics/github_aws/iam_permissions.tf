# potentially only needed for app runner - worth more investigation at some point
data "aws_iam_policy_document" "gh_iam_access" {
  statement {
    actions = [
      "iam:AttachRolePolicy",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:CreateRole",
      "iam:DeletePolicy",
      "iam:DeletePolicyVersion",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListEntitiesForPolicy",
      "iam:ListInstanceProfilesForRole",
      "iam:ListRoles",
      "iam:ListRolePolicies",
      "iam:ListPolicyVersions",
      "iam:ListPolicyTags",
      "iam:ListPolicies",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:SetDefaultPolicyVersion",
      "iam:UpdateAssumeRolePolicy",
      "iam:UpdateRole",
      "iam:TagPolicy",
      "iam:UntagPolicy",
      "iam:TagRole",
      "iam:UntagRole"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}