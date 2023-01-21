output "mongo_connection_string" {
  value     = replace(mongodbatlas_cluster.this.connection_strings[0].standard_srv, "mongodb+srv://", "mongodb+srv://${var.project_name}:${var.user_password}")
  sensitive = true
}
