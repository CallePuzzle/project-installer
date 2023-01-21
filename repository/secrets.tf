
resource "github_actions_secret" "project_id" {
  for_each = var.secrets

  repository      = github_repository.this.id
  secret_name     = each.key
  plaintext_value = each.value
}
