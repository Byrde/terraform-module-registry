# TFState Module Outputs
output "project_id" {
  description = "The tfstate project ID"
  value       = module.tfstate.tfstate_project_id
}

output "tfstate_bucket_names" {
  description = "Map of environment to tfstate bucket names"
  value       = { for k, v in module.tfstate.tfstate_buckets : k => v.name }
}

output "tfstate_bucket_urls" {
  description = "Map of environment to tfstate bucket URLs"
  value       = { for k, v in module.tfstate.tfstate_buckets : k => v.url }
}

# WIF Module Outputs
output "wif_project_id" {
  description = "The WIF project ID (service account home project)"
  value       = module.wif.wif_project_id
}

output "workload_identity_provider" {
  description = "The full workload identity provider resource name"
  value       = module.wif.workload_identity_provider
}

output "service_account_email" {
  description = "The service account email"
  value       = module.wif.service_account_email
}

output "service_account_member" {
  description = "The service account member format for IAM bindings"
  value       = module.wif.service_account_member
}
