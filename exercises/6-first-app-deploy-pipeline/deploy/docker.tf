data "aws_caller_identity" "this" {}
data "aws_ecr_authorization_token" "this" {}
data "aws_region" "this" {}
locals { ecr_address = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.this.name) }

provider "docker" {
  host = var.docker_host
  registry_auth {
    address  = local.ecr_address
    password = data.aws_ecr_authorization_token.this.password
    username = data.aws_ecr_authorization_token.this.user_name
  }
}

data "aws_ecr_repository" "private" {
  name = "${var.owner}_${var.ecr_repository}"
}

resource "docker_image" "exampleimage" {
  name = format("%v:%v", data.aws_ecr_repository.private.repository_url, var.fixed_image_tag)
  build { 
    context = "../node" # Path
    platform = "linux/amd64"
  } 
}

resource "docker_registry_image" "exampleimage" {
  keep_remotely = false
  name          = resource.docker_image.exampleimage.name
  triggers = {
    "sha_change_to" = docker_image.exampleimage.repo_digest
  }
}
