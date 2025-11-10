output "wif_project_id" {
  description = "The WIF project ID"
  value       = google_project.wif.project_id
}

output "workload_identity_provider" {
  description = "The full workload identity provider resource name"
  value       = google_iam_workload_identity_pool_provider.github_provider.name
}

output "service_account_email" {
  description = "The service account email"
  value       = google_service_account.github_actions.email
}

output "service_account_member" {
  description = "The service account member format for IAM bindings"
  value       = "serviceAccount:${google_service_account.github_actions.email}"
}

