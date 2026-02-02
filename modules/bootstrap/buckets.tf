# Grant owner access to the tfstate project
resource "google_project_iam_member" "tfstate_owner" {
  project = google_project.shared.project_id
  role    = "roles/owner"
  member  = "user:${var.project_owner_email}"

  depends_on = [google_project_service.apis]
}

# Create GCS buckets for environment state
resource "google_storage_bucket" "tfstate" {
  for_each = var.environments

  project       = google_project.shared.project_id
  name          = "tfstate"
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

  depends_on = [google_project_service.apis]
}

