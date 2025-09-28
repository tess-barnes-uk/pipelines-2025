output "role_to_assume" {
  value = aws_iam_role.github_action_role.arn
}
