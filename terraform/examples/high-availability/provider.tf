provider "aws" {
  region = local.aws_region

  default_tags {
    tags = {
      Terraform  = "true"
      Chirpstack = "true"
    }
  }
}
