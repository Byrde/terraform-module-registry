# GCP Terraform Modules

Terraform modules for bootstrapping GCP infrastructure with Terraform state management and GitHub Actions authentication via Workload Identity Federation.

## Modules

### `bootstrap`
Complete bootstrap solution that orchestrates both `tfstate` and `wif` modules. Use this for a complete setup.

### `tfstate`
Creates GCS buckets for Terraform state storage and backups with environment-specific retention policies.

### `wif`
Sets up Workload Identity Federation for secure GitHub Actions authentication without service account keys.

## Prerequisites

- GCP Organization or Billing Account access
- Terraform >= 1.0
- Appropriate GCP permissions to create projects and enable APIs

## Usage

### Using the Bootstrap Module (Recommended)

The `bootstrap` module provides a complete setup:

```hcl
module "gcp_bootstrap" {
  source = "github.com/Byrde/terraform-module-registry/terraform/modules/bootstrap?ref=main"

  billing_account_id  = "01AB10-A318CF-51627E"
  project_owner_email = "your-email@example.com"
  bucket_location     = "us-central1"
  github_organization = "your-org"
  github_repository   = "your-repo"

  environments = {
    dev = {
      tfstate_retention_versions = 3
      backup_retention_days      = 7
      backup_nearline_days       = 3
      backup_coldline_days       = null
    }
    staging = {
      tfstate_retention_versions = 5
      backup_retention_days      = 14
      backup_nearline_days       = 7
      backup_coldline_days       = null
    }
    production = {
      tfstate_retention_versions = 10
      backup_retention_days      = 60
      backup_nearline_days       = 7
      backup_coldline_days       = 30
    }
  }
}
```

#### Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `billing_account_id` | GCP billing account ID | string | yes |
| `project_owner_email` | Email address for project owner permissions | string | yes |
| `bucket_location` | GCS bucket location (e.g., US, EU, us-central1) | string | yes |
| `github_organization` | GitHub organization name | string | yes |
| `github_repository` | GitHub repository name | string | yes |
| `environments` | Map of environment configurations | map(object) | yes |

#### Environment Configuration

Each environment in the `environments` map supports:

- `tfstate_retention_versions` - Number of tfstate versions to retain
- `backup_retention_days` - Days before backups are deleted
- `backup_nearline_days` - Days before moving backups to Nearline storage
- `backup_coldline_days` - Days before moving to Coldline storage (optional)

#### Outputs

| Name | Description |
|------|-------------|
| `project_id` | Terraform state project ID |
| `tfstate_bucket_names` | Map of environment to tfstate bucket names |
| `tfstate_bucket_urls` | Map of environment to tfstate bucket URLs |
| `backup_project_id` | Backup project ID |
| `backup_bucket_names` | Map of environment to backup bucket names |
| `backup_bucket_urls` | Map of environment to backup bucket URLs |
| `wif_project_id` | Workload Identity Federation project ID |
| `workload_identity_provider` | Full workload identity provider resource name |
| `service_account_email` | GitHub Actions service account email |
| `service_account_member` | Service account member format for IAM bindings |

---

### Using Individual Modules

You can also use the `tfstate` and `wif` modules independently:

#### TFState Module

```hcl
resource "random_string" "suffix" {
  length  = 3
  special = false
  upper   = false
}

module "tfstate" {
  source = "github.com/Byrde/terraform-module-registry//terraform/modules/tfstate?ref=main"

  billing_account_id  = "01AB10-A318CF-51627E"
  project_owner_email = "your-email@example.com"
  bucket_location     = "us-central1"
  project_id_suffix   = random_string.suffix.result

  environments = {
    staging = {
      tfstate_retention_versions = 5
      backup_retention_days      = 14
      backup_nearline_days       = 7
      backup_coldline_days       = null
    }
    production = {
      tfstate_retention_versions = 10
      backup_retention_days      = 60
      backup_nearline_days       = 7
      backup_coldline_days       = 30
    }
  }
}
```

#### WIF Module

```hcl
resource "random_string" "suffix" {
  length  = 3
  special = false
  upper   = false
}

module "wif" {
  source = "github.com/Byrde/terraform-module-registry//terraform/modules/wif?ref=main"

  billing_account_id  = "01AB10-A318CF-51627E"
  project_owner_email = "your-email@example.com"
  project_id_suffix   = random_string.suffix.result
  github_organization = "your-org"
  github_repository   = "your-repo"
}
```

## Version Pinning

For production use, pin to a specific release or commit:

```hcl
module "gcp_bootstrap" {
  source = "github.com/Byrde/terraform-module-registry//terraform/modules/bootstrap?ref=v1.0.0"
  # ... configuration
}
```

## Module Outputs Usage

After applying the bootstrap module, use outputs in your GitHub Actions workflows:

```yaml
- name: Authenticate to Google Cloud
  uses: google-github-actions/auth@v2
  with:
    workload_identity_provider: ${{ secrets.WIF_PROVIDER }}
    service_account: ${{ secrets.SERVICE_ACCOUNT_EMAIL }}
```

Configure Terraform backend in your projects:

```hcl
terraform {
  backend "gcs" {
    bucket = "prj-shared-tfstate-production"
    prefix = "myapp/terraform/state"
  }
}
```

## What Gets Created

### Projects
- `prj-shared-tfstate-XXX` - Terraform state storage
- `prj-shared-backup-XXX` - Backup storage for databases/Identity Platform
- `prj-shared-wif-XXX` - Workload Identity Federation

### GCS Buckets (per environment)
- `prj-shared-tfstate-{environment}` - Terraform state files
- `prj-shared-backup-{environment}-XXX` - Application backups

### IAM Resources
- GitHub Actions Service Account
- Workload Identity Pool
- Workload Identity Provider (OIDC)
- Required IAM bindings

## Security Features

- **No Service Account Keys**: Uses Workload Identity Federation for keyless authentication
- **Versioning Enabled**: All buckets have versioning for disaster recovery
- **Lifecycle Management**: Automatic retention policies and storage class transitions
- **Least Privilege**: Service account only has necessary permissions
- **Repository Restriction**: WIF only accepts tokens from specified GitHub organization/repository

## Contributing

This is a personal repository, but suggestions and improvements are welcome via issues or pull requests.