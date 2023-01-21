resource "mongodbatlas_project" "this" {
  name   = var.project_name
  org_id = var.org_id
}

resource "mongodbatlas_cluster" "this" {
  project_id = mongodbatlas_project.this.id
  name       = "${var.project_name}-mongodb"

  provider_name               = "TENANT"
  backing_provider_name       = "AWS"
  provider_region_name        = "EU_WEST_1"
  provider_instance_size_name = "M0"
}

resource "mongodbatlas_database_user" "this" {
  project_id         = mongodbatlas_project.this.id
  username           = var.project_name
  password           = var.user_password
  auth_database_name = "admin"

  roles {
    database_name = "admin"
    role_name     = "readWriteAnyDatabase"
  }

  scopes {
    name = "monom-mongodb"
    type = "CLUSTER"
  }
}

resource "mongodbatlas_project_ip_access_list" "this" {
  project_id = mongodbatlas_project.this.id
  cidr_block = "0.0.0.0/0"
  comment    = var.project_name
}
