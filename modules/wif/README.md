# WIF Module

Creates Workload Identity Federation (WIF) for GitHub Actions to authenticate with GCP without service account keys.

## Features

- GitHub Actions OIDC authentication with GCP
- Service account with billing permissions (can link projects to billing accounts)
- Project creation permissions:
  - Organization level (when `organization_id` is provided)
  - Folder level (when `folder_id` is provided)
  - Billing account level (when neither organization nor folder is provided - for personal accounts)
- Supports both organizational and personal GCP accounts

## Usage

### With Organization (project creation enabled)

```hcl
module "wif" {
  source = "github.com/byrde/terraform-module-registry//modules/wif?ref=v1.0.0"

  billing_account_id  = "012345-ABCDEF-123456"
  project_owner_email = "owner@example.com"
  project_id_suffix   = "abc"
  github_organization = "your-org"
  github_repository   = "your-repo"
  organization_id     = "123456789012"
}
```

### Personal Account (project creation via billing account)

```hcl
module "wif" {
  source = "github.com/byrde/terraform-module-registry//modules/wif?ref=v1.0.0"

  billing_account_id  = "012345-ABCDEF-123456"
  project_owner_email = "owner@example.com"
  project_id_suffix   = "abc"
  github_organization = "your-org"
  github_repository   = "your-repo"
  # No organization_id or folder_id - uses billing.projectManager role instead
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| billing_account_id | GCP billing account ID | string | yes |
| project_owner_email | Email address of the project owner | string | yes |
| project_id_suffix | Random suffix for project IDs | string | yes |
| github_organization | GitHub organization name | string | yes |
| github_repository | GitHub repository name | string | yes |
| organization_id | GCP Organization ID for project creation | string | no |
| folder_id | GCP Folder ID for project creation | string | no |

## Outputs

| Name | Description |
|------|-------------|
| wif_project_id | The WIF project ID |
| workload_identity_provider | The full workload identity provider resource name |
| service_account_email | The service account email |
| service_account_member | The service account member format for IAM bindings |

