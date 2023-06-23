##############################################
# General Variables
##############################################

# --------------------------
# Required 
# --------------------------

variable "application_name_prefix" {
  description = "String to use as prefix on object names"
  type        = string

  # Optional validation for application_name_prefix
  # validation {
  #   condition     = var.application_name_prefix == "APPLICATION_NAME"
  #   error_message = "Application name prefix is mandatory and must be 'APPLICATION_NAME'"
  # }
}

variable "env_name" {
  description = "Environment name string to be used for decisions and name generation"
  type        = string

  validation {
    condition     = contains(["sbx", "dev", "stg", "prd"], var.env_name)
    error_message = "Environment value must be sbx, dev, stg or prd... other values are not allowed"
  }
}

# --------------------------
# Optional
# --------------------------

variable "aws_region" {
  description = "AWS region to target"
  type        = string
  default     = "us-east-1"
}

variable "gcp_region" {
  description = "GCP region to target"
  type        = string
  default     = "us-west1"
}

# variable "org_id" {
#   description = "ID of the organization where the projects are going to be attached"
#   type        = string
#   default     = "877469966260"
# }

##############################################
# Labeling Variables
##############################################

# --------------------------
# Required
# --------------------------

variable "cost_center" {
  description = "Name of the Cost Center to associate to this GCP resource"
  type        = string
}

variable "management_team" {
  description = "Name of the team managing this GCP resource"
  type        = string
}

variable "source_repo" {
  description = "name of repo which holds this code"
  type        = string
}

# --------------------------
# Optional
# --------------------------

variable "source_org" {
  description = "name of org which holds this repository"
  type        = string
  default     = "crunchyroll-et"
}
