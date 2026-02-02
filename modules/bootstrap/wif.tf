# Grant owner access to the WIF project
resource "google_project_iam_member" "wif_owner" {
  project = google_project.shared.project_id
  role    = "roles/owner"
  member  = "user:${var.project_owner_email}"

  depends_on = [google_project_service.apis]
}

# Create Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = google_project.shared.project_id
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub Actions Pool"
  description               = "Workload Identity Pool for GitHub Actions"

  depends_on = [
    google_project_service.apis,
    google_project_iam_member.wif_owner
  ]
}

# Create Workload Identity Provider for GitHub
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project                            = google_project.shared.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Provider"
  description                        = "OIDC provider for GitHub Actions"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  attribute_condition = "assertion.repository_owner == '${var.github_organization}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Create Service Account for GitHub Actions
resource "google_service_account" "github_actions" {
  project      = google_project.shared.project_id
  account_id   = "github-actions-sa"
  display_name = "GitHub Actions Service Account"
  description  = "Service account for GitHub Actions CI/CD"

  depends_on = [google_project_service.apis]
}

# Allow the GitHub Actions identity to impersonate the service account
resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_organization}/${var.github_repository}"
}

# Grant billing account user role to allow linking projects to billing account
resource "google_billing_account_iam_member" "github_actions_billing_user" {
  billing_account_id = var.billing_account_id
  role               = "roles/billing.user"
  member             = "serviceAccount:${google_service_account.github_actions.email}"

  depends_on = [google_service_account.github_actions]
}

# Grant billing project manager role for project creation when no org/folder parent exists
resource "google_billing_account_iam_member" "github_actions_billing_project_manager" {
  count = var.organization_id == null && var.folder_id == null ? 1 : 0

  billing_account_id = var.billing_account_id
  role               = "roles/billing.projectManager"
  member             = "serviceAccount:${google_service_account.github_actions.email}"

  depends_on = [google_service_account.github_actions]
}

# Grant project creator role at organization level (if organization is provided)
resource "google_organization_iam_member" "github_actions_project_creator" {
  count = var.organization_id != null ? 1 : 0

  org_id = var.organization_id
  role   = "roles/resourcemanager.projectCreator"
  member = "serviceAccount:${google_service_account.github_actions.email}"

  depends_on = [google_service_account.github_actions]
}

# Grant project creator role at folder level (if folder is provided)
resource "google_folder_iam_member" "github_actions_project_creator" {
  count = var.folder_id != null ? 1 : 0

  folder = var.folder_id
  role   = "roles/resourcemanager.projectCreator"
  member = "serviceAccount:${google_service_account.github_actions.email}"

  depends_on = [google_service_account.github_actions]
}

# Grant owner role at organization level (if organization is provided and folder is not)
resource "google_organization_iam_member" "github_actions_owner" {
  count = var.organization_id != null && var.folder_id == null ? 1 : 0

  org_id = var.organization_id
  role   = "roles/owner"
  member = "serviceAccount:${google_service_account.github_actions.email}"

  depends_on = [google_service_account.github_actions]
}

# Grant owner role at folder level (if folder is provided)
resource "google_folder_iam_member" "github_actions_owner" {
  count = var.folder_id != null ? 1 : 0

  folder = var.folder_id
  role   = "roles/owner"
  member = "serviceAccount:${google_service_account.github_actions.email}"

  depends_on = [google_service_account.github_actions]
}

# Grant the GitHub Actions service account access to tfstate buckets
resource "google_storage_bucket_iam_member" "tfstate_admin" {
  for_each = local.environments

  bucket = google_storage_bucket.tfstate[each.key].name
  role   = "roles/storage.objectAdmin"
  member = google_service_account_iam_member.workload_identity_user.member

  depends_on = [
    google_service_account_iam_member.workload_identity_user
  ]
}
