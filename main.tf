locals {
  _microservices = flatten([for env in var.environments : [
    for microservice in var.microservices : {
      environment  = env
      microservice = microservice
    }
  ]])
  microservices = { for item in local._microservices : "${item.microservice.name}-${item.environment}" => item.microservice }
  projects      = { for item in var.microservices : item.name => item }
}

module "cloud_run" {
  for_each                  = { for item, value in local.microservices : item => value if value.deploy_on_cloud_run == true }
  source                    = "./cloud-run"
  run_service_name          = each.key
  image                     = each.value.image != null ? each.value.image : "us-docker.pkg.dev/cloudrun/container/hello"
  region                    = each.value.region != null ? each.value.region : var.region
  env_vars                  = each.value.env_vars != null ? each.value.env_vars : []
  resources_limits_cpu      = each.value.resources_limits_cpu != null ? each.value.resources_limits_cpu : "1000m"
  resources_limits_memory   = each.value.resources_limits_memory != null ? each.value.resources_limits_memory : "512Mi"
  run_container_concurrency = each.value.run_container_concurrency != null ? each.value.run_container_concurrency : 80
  members_can_invoke        = each.value.members_can_invoke != null ? each.value.members_can_invoke : ["allUsers"]
  project                   = google_project.this.project_id
}

resource "google_artifact_registry_repository" "this" {
  count         = length({ for item, value in local.microservices : item => value if value.deploy_on_cloud_run == true }) > 0 ? 1 : 0
  repository_id = "cloud-run-source-deploy"
  location      = var.region
  project       = google_project.this.project_id
  format        = "DOCKER"
}

module "mongodbatlas" {
  for_each = var.mongo_org_id == null ? {} : zipmap(var.environments, var.environments)
  source   = "./mongodbatlas"

  project_name  = var.project_name
  org_id        = var.mongo_org_id
  user_password = var.mongo_user_password
}

module "repository" {
  for_each = local.projects
  source   = "./repository"

  name                 = each.key
  visibility           = each.value.repository_visibility != null ? each.value.repository_visibility : "private"
  teams_to_permissions = each.value.teams_to_permissions != null ? each.value.teams_to_permissions : {}

  deploy_on_cloudflare_worker = each.value.deploy_on_cloudflare_worker != null ? each.value.deploy_on_cloudflare_worker : false
  cloudflare_worker           = each.value.cloudflare_worker != null ? each.value.cloudflare_worker : { name = null, account_id = null }

  secrets = merge({
    "CF_API_TOKEN" = cloudflare_api_token.worker_edit[0].value
  }, var.repository_secrets)
}
