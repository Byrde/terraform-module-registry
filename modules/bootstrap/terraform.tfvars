billing_account_id  = "01AB10-A318CF-51627E"
bucket_location     = "northamerica-northeast1"
github_organization = "mallaire77"
github_repository   = "personal-gcp"
environments = {
  staging = {
    tfstate_retention_versions = 5
    backup_retention_days      = 14
    backup_nearline_days       = 7
    backup_coldline_days       = null
  }
  production = {
    tfstate_retention_versions = 5
    backup_retention_days      = 60
    backup_nearline_days       = 7
    backup_coldline_days       = 30
  }
}