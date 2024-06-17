terraform {
  required_version = ">= 1.3.2"

  backend "s3" {
    # See backend.tfvars for full configuration
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.50.0"
    }
  }
}
