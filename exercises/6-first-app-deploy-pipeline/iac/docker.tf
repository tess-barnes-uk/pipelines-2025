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

# adds temporary image to expected tag so app runner service doesn't fail on create

resource "docker_image" "exampleimage" {
  name = format("%v:%v", module.ecr.repository_url, var.fixed_image_tag)
  build { context = "../node" } # Path
}

resource "docker_registry_image" "exampleimage" {
  keep_remotely = false
  name          = resource.docker_image.exampleimage.name
}
