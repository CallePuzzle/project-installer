variable "project" {
  type = string
}

variable "role_binding" {
  type    = list(string)
  default = []
}

variable "account_id" {
  type = string
}

variable "display_name" {
  type = string
}

variable "generate_key" {
  type    = bool
  default = false
}
