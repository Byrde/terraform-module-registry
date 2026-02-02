resource "github_repository_environment" "environments" {
  for_each = var.environments

  repository  = var.github_repository
  environment = each.key
}

resource "github_actions_variable" "workload_identity_provider" {
  repository    = var.github_repository
  variable_name = "WORKLOAD_IDENTITY_PROVIDER"
  value         = google_iam_workload_identity_pool_provider.github_provider.name
}

resource "github_actions_variable" "service_account_email" {
  repository    = var.github_repository
  variable_name = "WORKLOAD_IDENTITY_SERVICE_ACCOUNT_EMAIL"
  value         = google_service_account.github_actions.email
}

resource "github_actions_environment_variable" "tfstate_buckets" {
  for_each = var.environments

  repository    = var.github_repository
  environment   = each.key
  variable_name = "TFSTATE_BUCKET"
  value         = google_storage_bucket.tfstate[each.key].name

  depends_on = [github_repository_environment.environments]
}