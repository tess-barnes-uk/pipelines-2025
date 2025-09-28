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

variable "app_port" {
  type        = number
  description = "The port the container will listen on (should match your code image)"
  default     = 8000 # this is the expected default for an app runner app
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

variable "role_prefix" {
  type        = string
  description = "A unique short name for your app, but in pascal case with no spaces or punctuation e.g. TessHello"
}
