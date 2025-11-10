# Bootstrap Terraform for GCP Infrastructure
# This creates shared infrastructure for Terraform state management and GitHub Actions authentication

provider "google" {
  billing_project = var.billing_account_id
}

# Random Project ID Suffix
resource "random_string" "project_id_suffix" {
  length  = 3
  special = false
  upper   = false

  lifecycle {
    prevent_destroy = true
  }
}

# Terraform State Module
# Creates tfstate and backup projects with GCS buckets
module "tfstate" {
  source = "../tfstate"

  billing_account_id  = var.billing_account_id
  project_owner_email = var.project_owner_email
  bucket_location     = var.bucket_location
  project_id_suffix   = random_string.project_id_suffix.result
  environments        = var.environments
}

# Workload Identity Federation Module
# Creates WIF project with GitHub Actions authentication
module "wif" {
  source = "../wif"

  billing_account_id  = var.billing_account_id
  project_owner_email = var.project_owner_email
  project_id_suffix   = random_string.project_id_suffix.result
  github_organization = var.github_organization
  github_repository   = var.github_repository
}

# Grant the GitHub Actions service account access to tfstate buckets
resource "google_storage_bucket_iam_member" "tfstate_admin" {
  for_each = var.environments

  bucket = module.tfstate.tfstate_buckets[each.key].name
  role   = "roles/storage.objectAdmin"
  member = module.wif.service_account_member

  depends_on = [
    module.tfstate,
    module.wif
  ]
}

# Grant billing account user role to allow linking projects to billing account
resource "google_billing_account_iam_member" "github_actions_billing_user" {
  billing_account_id = var.billing_account_id
  role               = "roles/billing.user"
  member             = module.wif.service_account_member

  depends_on = [module.wif]
}
