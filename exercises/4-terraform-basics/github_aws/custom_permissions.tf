data "aws_iam_policy_document" "terraform_backend_access" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.state_bucket}"]
    effect    = "Allow"
  }
  statement {
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["arn:aws:s3:::${var.state_bucket}/*"]
    effect    = "Allow"
  }
  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${var.state_bucket}/*"]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["${var.state_bucket}/*/*.tflock"]
    }
    effect = "Allow"
  }
  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey" 
    ]
    resources = [
        "arn:aws:kms:*:${var.account_id}:key/*",
    ]
    condition {
      test = "ForAnyValue:StringLike"
      variable = "kms:ResourceAliases"
      values = [var.state_key_alias]
    }       
    effect = "Allow"
  }
}
