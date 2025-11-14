# TFState Module

Creates GCP project and GCS buckets for Terraform state management with versioning and lifecycle policies.

## Usage

### With Folder Parent

```hcl
module "tfstate" {
  source = "github.com/byrde/terraform-module-registry//modules/tfstate?ref=v1.0.0"

  billing_account_id  = "012345-ABCDEF-123456"
  project_owner_email = "owner@example.com"
  bucket_location     = "US"
  project_id_suffix   = "abc"
  folder_id           = "123456789012"
  
  environments = {
    dev = {
      tfstate_retention_versions = 5
    }
  }
}
```

### With Organization Parent

```hcl
module "tfstate" {
  source = "github.com/byrde/terraform-module-registry//modules/tfstate?ref=v1.0.0"

  billing_account_id  = "012345-ABCDEF-123456"
  project_owner_email = "owner@example.com"
  bucket_location     = "US"
  project_id_suffix   = "abc"
  organization_id     = "123456789012"
  
  environments = {
    dev = {
      tfstate_retention_versions = 5
    }
  }
}
```

### Without Parent (Personal Account)

```hcl
module "tfstate" {
  source = "github.com/byrde/terraform-module-registry//modules/tfstate?ref=v1.0.0"

  billing_account_id  = "012345-ABCDEF-123456"
  project_owner_email = "owner@example.com"
  bucket_location     = "US"
  project_id_suffix   = "abc"
  
  environments = {
    dev = {
      tfstate_retention_versions = 5
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
| project_id_suffix | Random suffix for project IDs | string | yes |
| environments | Environment configurations for tfstate buckets | map(object) | yes |
| organization_id | GCP Organization ID where projects will be created | string | no |
| folder_id | GCP Folder ID where projects will be created (takes precedence over organization_id) | string | no |

## Outputs

| Name | Description |
|------|-------------|
| tfstate_project_id | The tfstate project ID |
| tfstate_buckets | Map of environment to tfstate bucket resources |

