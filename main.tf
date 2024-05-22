# ***************************************
# VPC
# ***************************************
module "vpc" {
  source = "./modules/vpc"

  # AWS
  availability_zones = var.aws_availability_zones

  # VPC
  vpc_name                 = var.vpc_name
  vpc_cidr_block           = var.vpc_cidr_block
  vpc_enable_dns_support   = var.vpc_enable_dns_support
  vpc_enable_dns_hostnames = var.vpc_enable_dns_hostnames

  # Subnets
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  # NGW
  single_nat_gateway = var.single_nat_gateway

  # Tags
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
  vpc_tags            = var.vpc_tags
}

# ***************************************
# EKS
# ***************************************
module "eks" {
  source = "./modules/eks"

  # VPC
  vpc_id                 = module.vpc.vpc_id
  vpc_private_subnet_ids = module.vpc.private_subnets_ids

  # EKS
  eks_cluster_name                                = var.eks_cluster_name
  eks_cluster_version                             = var.eks_cluster_version
  eks_log_types                                   = var.eks_log_types
  eks_authentication_mode                         = var.eks_authentication_mode
  eks_bootstrap_cluster_creator_admin_permissions = var.eks_bootstrap_cluster_creator_admin_permissions
  eks_endpoint_private_access                     = var.eks_endpoint_private_access
  eks_endpoint_public_access                      = var.eks_endpoint_public_access

  # EKS addons
  eks_addon_preserve                    = var.eks_addon_preserve
  eks_addon_resolve_conflicts_on_update = var.eks_addon_resolve_conflicts_on_update
  eks_vpc_cni_version                   = var.eks_vpc_cni_version
  eks_coredns_version                   = var.eks_coredns_version
  eks_kube_proxy_version                = var.eks_kube_proxy_version

  # EKS Cluster auth
  eks_aws_auth_roles    = var.eks_aws_auth_roles
  eks_aws_auth_users    = var.eks_aws_auth_users
  eks_aws_auth_accounts = var.eks_aws_auth_accounts

  # EKS KMS encryption
  kms_key_usage           = var.kms_key_usage
  kms_enable_key_rotation = var.kms_enable_key_rotation

  # EKS CloudWatch log retention
  cloudwatch_retention_in_days = var.cloudwatch_retention_in_days

  # EKS Node Group
  node_group_min_size                   = var.node_group_min_size
  node_group_max_size                   = var.node_group_max_size
  node_group_desired_size               = var.node_group_desired_size
  node_group_ami_type                   = var.node_group_ami_type
  node_group_capacity_type              = var.node_group_capacity_type
  node_group_disk_size                  = var.node_group_disk_size
  node_group_instance_types             = var.node_group_instance_types
  node_group_max_unavailable_percentage = var.node_group_max_unavailable_percentage

  # Tags
  eks_tags = var.eks_tags
}

# ***************************************
# RDS
# ***************************************
module "rds" {
  source = "./modules/rds"

  # AWS
  aws_region = var.aws_region

  # VPC
  vpc_id                   = module.vpc.vpc_id
  database_subnet_ids      = module.vpc.database_subnet_ids
  rds_db_subnet_group_name = module.vpc.database_subnet_group_name

  # RDS
  rds_name                                = var.rds_name
  rds_storage_type                        = var.rds_storage_type
  rds_storage_size                        = var.rds_storage_size
  rds_max_storage_size                    = var.rds_max_storage_size
  rds_instance_type                       = var.rds_instance_type
  rds_storage_encrypted                   = var.rds_storage_encrypted
  rds_skip_final_snapshot                 = var.rds_skip_final_snapshot
  rds_backup_retention_period             = var.rds_backup_retention_period
  rds_db_port                             = var.rds_db_port
  rds_iam_database_authentication_enabled = var.rds_iam_database_authentication_enabled
  rds_multi_az                            = var.rds_multi_az
  rds_read_replica                        = var.rds_read_replica

  # DB
  pg_name           = var.pg_name
  pg_engine_version = var.pg_engine_version
  pg_ssl_required   = var.pg_ssl_required
  pg_username       = var.pg_username
  pg_log_exports    = var.pg_log_exports

  # IAM
  oidc_provider     = module.eks.oidc_provider
  oidc_provider_arn = module.eks.oidc_provider_arn

  # Snapshot restore
  rds_deploy_from_snapshot = var.rds_deploy_from_snapshot
  rds_snapshot_identifier  = var.rds_snapshot_identifier

  # Monitoring
  cloudwatch_alarm_action_arns = var.cloudwatch_alarm_action_arns
}
