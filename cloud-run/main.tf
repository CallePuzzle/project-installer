module "cloud_run_service_account" {
  source = "../service-account"

  project      = var.project
  account_id   = "${var.run_service_name}-sa"
  display_name = "Service account for ${var.run_service_name}"
}

resource "google_cloud_run_service" "this" {
  name     = var.run_service_name
  location = var.region
  project  = var.project

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all"
    }
  }

  template {
    spec {
      containers {
        image = var.image
        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.value["name"]
            value = env.value["value"]
          }
        }
        resources {
          limits = {
            cpu    = var.resources_limits_cpu
            memory = var.resources_limits_memory
          }
        }
      }
      container_concurrency = var.run_container_concurrency
      service_account_name  = module.cloud_run_service_account.email
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_binding" "this" {
  service  = google_cloud_run_service.this.name
  project  = var.project
  location = var.region

  role    = "roles/run.invoker"
  members = var.members_can_invoke
}
