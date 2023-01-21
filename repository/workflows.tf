resource "github_repository_file" "release" {
  repository          = github_repository.this.name
  branch              = github_branch_default.main.branch
  file                = ".github/workflows/release.yaml"
  content             = file("${path.module}/workflows/release-workflow.yaml")
  commit_message      = "Automatic update. Managed by Terraform"
  overwrite_on_create = true

  depends_on = [github_repository_file.release_conf]
}

resource "github_repository_file" "release_conf" {
  repository          = github_repository.this.name
  branch              = github_branch_default.main.branch
  file                = ".releaserc.yaml"
  content             = file("${path.module}/workflows/releaserc.yaml")
  commit_message      = "Automatic update. Managed by Terraform"
  overwrite_on_create = true
}

resource "github_repository_file" "wrangler" {
  count = var.deploy_on_cloudflare_worker ? 1 : 0

  repository          = github_repository.this.name
  branch              = github_branch_default.main.branch
  file                = "wrangler.toml"
  content             = templatefile("${path.module}/workflows/wrangler.toml.tftpl", { cloudflare_worker = var.cloudflare_worker })
  commit_message      = "Managed by Terraform"
  overwrite_on_create = true
}

resource "github_repository_file" "deploy_cloudflare" {
  count = var.deploy_on_cloudflare_worker ? 1 : 0

  repository          = github_repository.this.name
  branch              = github_branch_default.main.branch
  file                = ".github/workflows/deploy.yaml"
  content             = file("${path.module}/workflows/deploy-on-cloudflare-worker.yaml")
  commit_message      = "Managed by Terraform"
  overwrite_on_create = true
}
