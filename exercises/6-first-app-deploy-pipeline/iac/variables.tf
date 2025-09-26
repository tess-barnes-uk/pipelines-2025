variable "owner" {
  type        = string
  description = "Ensures appropriate sandbox tagging, this should be your name. There is no default"
}

variable "repo_name" {
  type        = string
  description = "Your repository name so resources will be tagged appropriately. There is no default"
}

variable "org_name" {
  type        = string
  description = "Your repository organisation name so resources will be tagged appropriately"
  default     = "MadeTechAcademy"
}

variable "app_name" {
  type        = string
  description = "A short name for your app, it will be combined with owner to make it unique. There is no default"
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
  default     = "unix:///var/run/docker.sock" # works for github action ubuntu box
}
