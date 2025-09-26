output "vpc_id" {
  description = "VPC selected for app runner to exist within"
  value       = module.vpc.vpc_id
}

output "ecr_repository" {
  description = "ECR source for the app runner"
  value       = module.ecr.repository_url
}