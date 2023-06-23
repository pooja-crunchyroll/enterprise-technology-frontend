terraform {
  required_version = "~> 1.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.48"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.50"
    }
  }
}
