output "vpc_id" {
  value = module.vpc.vpc_id
}

output "database_subnet_group_name" {
  value = module.vpc.database_subnet_group
}

output "database_subnet_ids" {
  value = module.vpc.database_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "igw_id" {
  value = module.vpc.igw_id
}