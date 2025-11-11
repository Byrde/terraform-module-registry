variable "organization_id" {
  description = "GCP Organization ID where projects will be created (optional, not needed for personal accounts)"
  type        = string
  default     = null
}

variable "folder_id" {
  description = "GCP Folder ID where projects will be created (optional)"
  type        = string
  default     = null
}

variable "billing_account_id" {
  description = "The GCP billing account ID"
  type        = string
}

variable "project_owner_email" {
  description = "Email address of the project owner to grant owner permissions"
  type        = string
}

variable "bucket_location" {
  description = "The location for the GCS buckets (e.g., US, EU, us-central1)"
  type        = string
}

variable "github_organization" {
  description = "GitHub organization name"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
}

variable "environments" {
  description = "Map of environment configurations for tfstate and backup buckets"
  type = map(object({
    tfstate_retention_versions = number
    backup_retention_days      = number
    backup_nearline_days       = number
    backup_coldline_days       = optional(number)
  }))
}