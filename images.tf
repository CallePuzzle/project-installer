locals {
  public_image_bucket_name = var.public_image_bucket_name != null ? var.public_image_bucket_name : "${var.project_name}-images"
}

resource "google_storage_bucket" "public_image" {
  name          = local.public_image_bucket_name
  location      = var.location
  force_destroy = true

  project = google_project.this.project_id
}

resource "google_storage_bucket_access_control" "public_image_rule" {
  bucket = google_storage_bucket.public_image.name
  role   = "READER"
  entity = "allUsers"
}
