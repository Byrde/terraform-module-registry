output "tfstate_project_id" {
  description = "The tfstate project ID"
  value       = google_project.tfstate.project_id
}

output "tfstate_buckets" {
  description = "Map of environment to tfstate bucket resources"
  value       = google_storage_bucket.tfstate
}

output "backup_project_id" {
  description = "The backup project ID"
  value       = google_project.backup.project_id
}

output "backup_buckets" {
  description = "Map of environment to backup bucket resources"
  value       = google_storage_bucket.backups
}

