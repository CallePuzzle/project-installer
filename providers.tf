terraform {
  required_providers {
    tfe = {
      source = "hashicorp/tfe"
    }
    google = {
      source = "hashicorp/google"
    }
    github = {
      source = "integrations/github"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
  required_version = ">= 1.3"
}
