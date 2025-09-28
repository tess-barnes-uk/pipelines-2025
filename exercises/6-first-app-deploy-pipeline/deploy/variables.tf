variable "owner" {
  type        = string
  description = "Ensures appropriate sandbox tagging, this should be your name. There is no default"
}

variable "ecr_repository" {
  type        = string
  description = "A short name for your image, it will be combined with owner to make it unique. There is no default"
}

variable "fixed_image_tag" {
  type        = string
  description = "Tag for the built image, should match the app runner and iac configs"
}

variable "docker_host" {
  type        = string
  description = "unix format uri for the docker endpoint on local machine. Find this by running docker context ls."
  default     = "unix:///var/run/docker.sock"
}
