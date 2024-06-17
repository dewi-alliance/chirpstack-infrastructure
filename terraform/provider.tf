provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Terraform  = "true"
      Chirpstack = "true"
    }
  }
}
