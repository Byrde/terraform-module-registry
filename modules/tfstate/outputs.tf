output "tfstate_project_id" {
  description = "The tfstate project ID"
  value       = google_project.tfstate.project_id
}

output "tfstate_buckets" {
  description = "Map of environment to tfstate bucket resources"
  value       = google_storage_bucket.tfstate
}

