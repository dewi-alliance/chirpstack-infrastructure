terraform {
  required_version = ">= 1.3.2"

  backend "s3" {
    # Provide full configuration in backend.tfvars
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.50.0"
    }
  }
}
