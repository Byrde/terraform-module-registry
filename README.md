# Terraform Module Registry

Collection of reusable Terraform modules for platform engineering, focusing on GCP infrastructure, GitHub integration, and Terraform Cloud automation.

## Module Structure
Each module follows a consistent structure:
```
modules/
├── module-name/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   ├── README.md
│   └── examples/
│       └── basic/
│           ├── main.tf
│           └── outputs.tf
```

## Using Modules from GitHub
Modules in this registry can be sourced directly from GitHub using standard Terraform syntax.

**Basic GitHub Source Syntax:**
```hcl
module "example" {
  source = "github.com/your-org/terraform-module-registry//modules/module-name?ref=v1.0.0"
  # ... module variables
}
```

The `//modules/module-name` syntax specifies the subdirectory path within the repository, and `?ref=` allows you to pin to a specific version, tag, or branch.

## Usage
Example of consuming a module from this registry:

```hcl
module "bootstrap" {
  source = "github.com/your-org/terraform-module-registry//modules/bootstrap?ref=v1.0.0"

  billing_account_id  = "01234A-567890-ABCDEF"
  project_owner_email = "platform-team@example.com"
  bucket_location     = "US"
  github_organization = "your-org"
  github_repository   = "your-repo"
  
  environments = {
    # ... environment configuration
  }
}
```

Refer to each module's README for detailed documentation on available variables and outputs.