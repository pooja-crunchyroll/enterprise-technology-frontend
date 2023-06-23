# data "google_project" "project" {
#   project_id = "my-project-id"
# }

# Gain access to the effective Account ID, User ID, and ARN in which Terraform is authorized
data "aws_caller_identity" "current" {}
