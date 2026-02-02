# Bootstrap Terraform for GCP Infrastructure
# This creates shared infrastructure for Terraform state management and GitHub Actions authentication

provider "google" {
  billing_project = var.billing_account_id
}

# Random Project ID Suffix
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false

  lifecycle {
    prevent_destroy = true
  }
}

# Create the tfstate project
resource "google_project" "shared" {
  name            = "shared-${random_string.suffix.result}"
  project_id      = "shared-${random_string.suffix.result}"
  billing_account = var.billing_account_id
  folder_id       = var.folder_id
  org_id          = var.folder_id == null ? var.organization_id : null

  lifecycle {
    prevent_destroy = true
  }
}

# Enable required APIs
resource "google_project_service" "apis" {
  for_each = toset([
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudbilling.googleapis.com",
    "servicenetworking.googleapis.com",
    "storage.googleapis.com"
  ])

  project            = google_project.shared.project_id
  service            = each.value
  disable_on_destroy = false

  depends_on = [google_project.shared]
}