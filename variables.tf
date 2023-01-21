variable "project_name" {
  type = string
}

variable "project_id" {
  type    = string
  default = null
}

variable "organization" {
  type = string
}

variable "billing_account" {
  type    = string
  default = null
}

variable "google_services" {
  type = list(string)
  default = [
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "iam.googleapis.com",
    "artifactregistry.googleapis.com",
  ]
}

variable "region" {
  type    = string
  default = "europe-southwest1"
}

variable "location" {
  type    = string
  default = "EU"
}

variable "public_image_bucket_name" {
  type    = string
  default = null
}

variable "mongo_org_id" {
  type    = string
  default = null
}

variable "mongo_user_password" {
  type      = string
  sensitive = true
  default   = null
}

variable "environments" {
  type    = list(string)
  default = ["dev"]
}

variable "microservices" {
  type = list(object({
    name                = string
    deploy_on_cloud_run = optional(bool, false)
    cloud_run = optional(object({
      image  = optional(string)
      region = optional(string)
      env_vars = optional(list(object({
        name  = string
        value = string
      })))
      resources_limits_cpu      = optional(string)
      resources_limits_memory   = optional(string)
      run_container_concurrency = optional(number)
      members_can_invoke        = optional(list(string))
    }))
    deploy_on_cloudflare_worker = optional(bool, false)
    cloudflare_worker = optional(object({
      name       = string
      account_id = string
    }))
    // Repository variables
    repository_visibility = optional(string)
    teams_to_permissions  = optional(map(string))
  }))
}

variable "repository_secrets" {
  type    = map(string)
  default = {}
}
