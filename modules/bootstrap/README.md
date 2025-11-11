# Bootstrap Module

Bootstraps GCP infrastructure for Terraform state management and GitHub Actions authentication.

## Usage

### With Folder Parent

```hcl
module "bootstrap" {
  source = "github.com/byrde/terraform-module-registry//modules/bootstrap?ref=v1.0.0"

  billing_account_id  = "012345-ABCDEF-123456"
  project_owner_email = "owner@example.com"
  bucket_location     = "US"
  github_organization = "your-org"
  github_repository   = "your-repo"
  folder_id           = "123456789012"
  
  environments = {
    dev = {
      tfstate_retention_versions = 5
      backup_retention_days      = 30
      backup_nearline_days       = 7
      backup_coldline_days       = 14
    }
  }
}
```

### With Organization Parent

```hcl
module "bootstrap" {
  source = "github.com/byrde/terraform-module-registry//modules/bootstrap?ref=v1.0.0"

  billing_account_id  = "012345-ABCDEF-123456"
  project_owner_email = "owner@example.com"
  bucket_location     = "US"
  github_organization = "your-org"
  github_repository   = "your-repo"
  organization_id     = "123456789012"
  
  environments = {
    dev = {
      tfstate_retention_versions = 5
      backup_retention_days      = 30
      backup_nearline_days       = 7
      backup_coldline_days       = 14
    }
  }
}
```

### Personal Account (no parent)

```hcl
module "bootstrap" {
  source = "github.com/byrde/terraform-module-registry//modules/bootstrap?ref=v1.0.0"

  billing_account_id  = "012345-ABCDEF-123456"
  project_owner_email = "owner@example.com"
  bucket_location     = "US"
  github_organization = "your-org"
  github_repository   = "your-repo"
  # No organization_id or folder_id - uses billing.projectManager role instead
  
  environments = {
    dev = {
      tfstate_retention_versions = 5
      backup_retention_days      = 30
      backup_nearline_days       = 7
      backup_coldline_days       = 14
    }
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| billing_account_id | GCP billing account ID | string | yes |
| project_owner_email | Email address of the project owner | string | yes |
| bucket_location | Location for GCS buckets | string | yes |
| github_organization | GitHub organization name | string | yes |
| github_repository | GitHub repository name | string | yes |
| environments | Environment configurations for tfstate and backup buckets | map(object) | yes |
| organization_id | GCP Organization ID where projects will be created | string | no |
| folder_id | GCP Folder ID where projects will be created (takes precedence over organization_id) | string | no |

## Outputs

| Name | Description |
|------|-------------|
| project_id | The tfstate project ID |
| tfstate_bucket_names | Map of environment to tfstate bucket names |
| tfstate_bucket_urls | Map of environment to tfstate bucket URLs |
| backup_project_id | The backup project ID |
| backup_bucket_names | Map of environment to backup bucket names |
| backup_bucket_urls | Map of environment to backup bucket URLs |
| wif_project_id | The WIF project ID |
| workload_identity_provider | The full workload identity provider resource name |
| service_account_email | The service account email |
| service_account_member | The service account member format for IAM bindings |

