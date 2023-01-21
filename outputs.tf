output "mongo_connection_string" {
  value     = try(module.mongodbatlas[*].mongo_connection_string, null)
  sensitive = true
}
