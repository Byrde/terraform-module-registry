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

variable "github_organization" {
  description = "GitHub organization name"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
}

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

