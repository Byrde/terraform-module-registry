variable "billing_account_id" {
  description = "The GCP billing account ID"
  type        = string
}

variable "project_owner_email" {
  description = "Email address of the project owner to grant owner permissions"
  type        = string
}

variable "bucket_location" {
  description = "The location for the GCS buckets"
  type        = string
}

variable "project_id_suffix" {
  description = "Random suffix for project IDs"
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

