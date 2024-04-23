locals {
  availability_zones = [var.availability_zone_1, var.availability_zone_2]
  public_subnets   = [var.public_subnet_1, var.public_subnet_2]
  private_subnets  = [var.private_subnet_1, var.private_subnet_2]
  database_subnets = [var.database_subnet_1, var.database_subnet_2]
}
