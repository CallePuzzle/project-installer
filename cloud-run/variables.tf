variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-southwest1"
}

variable "run_service_name" {
  type    = string
  default = null
}

variable "image" {
  type    = string
  default = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "env_vars" {
  type = list(object(
    {
      name  = string
      value = string
    }
  ))
  default = []
}

variable "resources_limits_cpu" {
  type    = string
  default = "1000m"
}

variable "resources_limits_memory" {
  type    = string
  default = "512Mi"
}

variable "run_container_concurrency" {
  type    = number
  default = 80
}

variable "members_can_invoke" {
  type = list(string)
  default = [
    "allUsers"
  ]
}
