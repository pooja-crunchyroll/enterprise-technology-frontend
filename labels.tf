locals {
  common_labels = {
    env             = var.env_name
    app             = var.application_name_prefix
    provisioner     = "terraform"
    source_repo     = var.source_repo
    source_org      = var.source_org
    cost_center     = var.cost_center
    management_team = var.management_team
  }
}
