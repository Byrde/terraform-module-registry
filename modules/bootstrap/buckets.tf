# Grant owner access to the tfstate project
resource "google_project_iam_member" "tfstate_owner" {
  project = google_project.shared.project_id
  role    = "roles/owner"
  member  = "user:${var.project_owner_email}"

  depends_on = [google_project_service.apis]
}

# Create GCS buckets for environment state
resource "google_storage_bucket" "tfstate" {
  for_each = local.environments

  project       = google_project.shared.project_id
  name          = "tfstate-${each.value}-${random_string.suffix.result}"
  location      = var.region
  force_destroy = false

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 5
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

