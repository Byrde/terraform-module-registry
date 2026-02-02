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

variable "project_id" {
  description = "Existing GCP project ID to use; if set, the module will not create a new project (bring your own project)"
  type        = string
  default     = null
}

variable "region" {
  description = "The region for the GCP resources"
  type        = string
  default     = "northamerica-northeast1"
}

variable "billing_account_id" {
  description = "The GCP billing account ID"
  type        = string
}

variable "project_owner_email" {
  description = "Email address of the project owner to grant owner permissions"
  type        = string
}

variable "additional_apis" {
  description = "List of additional APIs to enable"
  type        = list(string)
  default     = []
}

variable "environments" {
  description = "List of environments (values are lowercased internally)"
  type        = list(string)
  default     = []
}

variable "github_organization" {
  description = "GitHub organization name"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
}