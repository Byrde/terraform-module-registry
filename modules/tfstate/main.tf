# Create the tfstate project
resource "google_project" "tfstate" {
  name            = "prj-shared-tfstate-${var.project_id_suffix}"
  project_id      = "prj-shared-tfstate-${var.project_id_suffix}"
  billing_account = var.billing_account_id
  folder_id       = var.folder_id
  org_id          = var.folder_id == null ? var.organization_id : null

  lifecycle {
    prevent_destroy = true
  }
}

# Enable required APIs
resource "google_project_service" "tfstate_services" {
  for_each = toset([
    "storage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
  ])

  project            = google_project.tfstate.project_id
  service            = each.value
  disable_on_destroy = false
}

# Grant owner access to the tfstate project
resource "google_project_iam_member" "tfstate_owner" {
  project = google_project.tfstate.project_id
  role    = "roles/owner"
  member  = "user:${var.project_owner_email}"

  depends_on = [google_project_service.tfstate_services]
}

# Create GCS buckets for environment state
resource "google_storage_bucket" "tfstate" {
  for_each = var.environments

  project       = google_project.tfstate.project_id
  name          = "prj-shared-tfstate-${each.key}-${var.project_id_suffix}"
  location      = var.bucket_location
  force_destroy = false

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = each.value.tfstate_retention_versions
    }
    action {
      type = "Delete"
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [google_project_service.tfstate_services]
}

