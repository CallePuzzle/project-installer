resource "google_project" "this" {
  name            = var.project_name
  project_id      = var.project_id
  org_id          = var.organization
  billing_account = var.billing_account
}

resource "google_project_service" "this" {
  for_each = zipmap(var.google_services, var.google_services)

  project = google_project.this.project_id
  service = each.value
}
