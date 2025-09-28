// ecr
module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 1.6.0"

  repository_force_delete         = true
  repository_name                 = "${var.owner}_${var.ecr_repository}"
  repository_image_tag_mutability = "MUTABLE"
  create_lifecycle_policy         = false
}
