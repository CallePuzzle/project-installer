data "cloudflare_api_token_permission_groups" "all" {}

locals {
  any_microservices_use_cloudflare_worker = length([for microservice in var.microservices : microservice if microservice.deploy_on_cloudflare_worker]) > 0
}

resource "cloudflare_api_token" "worker_edit" {
  count = local.any_microservices_use_cloudflare_worker ? 1 : 0

  name = "worker_edit"

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.account["Pages Write"],
      data.cloudflare_api_token_permission_groups.all.account["Workers R2 Storage Write"],
      data.cloudflare_api_token_permission_groups.all.account["Workers Tail Read"],
      data.cloudflare_api_token_permission_groups.all.account["Workers KV Storage Write"],
      data.cloudflare_api_token_permission_groups.all.account["Workers Scripts Write"],
      data.cloudflare_api_token_permission_groups.all.account["Account Settings Read"],
    ]
    resources = {
      "com.cloudflare.api.account.*" = "*"
    }
  }

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.zone["Workers Routes Write"],
    ]
    resources = {
      "com.cloudflare.api.account.zone.*" = "*"
    }
  }
}
