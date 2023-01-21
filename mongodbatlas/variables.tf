variable "project_name" {
  type = string
}

variable "org_id" {
  type    = string
  default = null
}

variable "user_password" {
  type      = string
  sensitive = true
  default   = null
}