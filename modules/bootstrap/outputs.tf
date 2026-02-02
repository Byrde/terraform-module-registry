output "shared_project_id" {
  description = "The shared project ID (created or bring-your-own)"
  value       = local.project_id
}

output "enabled_apis" {
  description = "List of APIs enabled in the project"
  value       = [for v in google_project_service.apis : v.service]
}

output "environments" {
  description = "Array of environment names (lowercase)"
  value       = tolist(local.environments)
}

output "tfstate_bucket_names" {
  description = "Map of environment to tfstate bucket names"
  value       = { for k, v in google_storage_bucket.tfstate : k => v.name }
}

output "tfstate_bucket_urls" {
  description = "Map of environment to tfstate bucket URLs"
  value       = { for k, v in google_storage_bucket.tfstate : k => v.url }
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
  value       = google_service_account_iam_member.workload_identity_user.member
}

output "github_repository_environment_names" {
  description = "Array of environment names"
  value       = keys(github_repository_environment.environments)
}

output "github_actions_global_variable_names" {
  description = "Array of repository-level variable names"
  value = [
    github_actions_variable.workload_identity_provider.variable_name,
    github_actions_variable.service_account_email.variable_name,
  ]
}

output "github_actions_environment_variable_names" {
  description = "Array of per-environment variable names"
  value       = [for k, v in github_actions_environment_variable.tfstate_buckets : v.variable_name]
}