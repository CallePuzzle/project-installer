output "private_key" {
  sensitive = true
  value     = try(google_service_account_key.this[0].private_key, null)
}

output "email" {
  sensitive = true
  value     = google_service_account.this.email
}
