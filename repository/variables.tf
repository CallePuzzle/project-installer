variable "name" {
  type = string
}

variable "visibility" {
  type    = string
  default = "private"
}

variable "teams_to_permissions" {
  type    = map(string)
  default = {}
}

variable "deploy_on_cloudflare_worker" {
  type    = bool
  default = false
}

variable "cloudflare_worker" {
  type = object({
    name       = string
    account_id = string
  })
  default = {
    name       = null
    account_id = null
  }
}

variable "secrets" {
  type    = map(string)
  default = {}
}
