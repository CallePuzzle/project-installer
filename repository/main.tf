resource "github_repository" "this" {
  name        = var.name
  description = var.name

  visibility = var.visibility

  delete_branch_on_merge = true

  has_issues    = true
  has_projects  = false
  has_wiki      = true
  has_downloads = false

  auto_init = true

  vulnerability_alerts = var.visibility == "private" ? false : true
}

data "github_team" "this" {
  for_each = var.teams_to_permissions
  slug     = each.key
}

resource "github_team_repository" "this" {
  for_each   = var.teams_to_permissions
  team_id    = data.github_team.this[each.key].id
  repository = github_repository.this.id
  permission = each.value
}

resource "github_branch_default" "main" {
  repository = github_repository.this.name
  branch     = "main"
}

//resource "github_branch_protection" "main" {
//  repository_id = github_repository.this.id
//  pattern       = "main"
//}
