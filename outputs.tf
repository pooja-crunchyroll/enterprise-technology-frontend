output "aws_account_id" {
  description = "Account which terraform was run on"
  value       = data.aws_caller_identity.current.account_id
}

output "application_name_prefix" {
  description = "string to prepend to all resource names"
  value       = var.application_name_prefix
}

output "aws_region" {
  description = "AWS Region to target"
  value       = var.aws_region
}

output "gcp_region" {
  description = "GCP Region to target"
  value       = var.gcp_region
}
