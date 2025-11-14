variable "organization_id" {
  description = "GCP Organization ID where projects will be created (optional)"
  type        = string
  default     = null
}

variable "folder_id" {
  description = "GCP Folder ID where projects will be created (optional, takes precedence over organization_id)"
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

variable "project_id_suffix" {
  description = "Random suffix for project IDs"
  type        = string
}

variable "bucket_location" {
  description = "The location for the GCS buckets"
  type        = string
}


variable "environments" {
  description = "Map of environment configurations for tfstate buckets"
  type = map(object({
    tfstate_retention_versions = number
  }))
}
