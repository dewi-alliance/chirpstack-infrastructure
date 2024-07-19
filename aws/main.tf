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
  eks_public_access_cidrs                         = var.eks_public_access_cidrs

  # EKS addons
  eks_addon_preserve                    = var.eks_addon_preserve
  eks_addon_resolve_conflicts_on_update = var.eks_addon_resolve_conflicts_on_update
  eks_vpc_cni_version                   = var.eks_vpc_cni_version
  eks_coredns_version                   = var.eks_coredns_version
  eks_kube_proxy_version                = var.eks_kube_proxy_version
  eks_ebs_csi_version                   = var.eks_ebs_csi_version

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
  with_rds_read_replica                   = var.with_rds_read_replica

  # DB
  pg_name           = var.pg_name
  pg_engine_version = var.pg_engine_version
  pg_ssl_required   = var.pg_ssl_required
  pg_username       = var.pg_username
  pg_log_exports    = var.pg_log_exports
  pg_family         = var.pg_family

  # Snapshot restore
  rds_deploy_from_snapshot = var.rds_deploy_from_snapshot
  rds_snapshot_identifier  = var.rds_snapshot_identifier

  # Monitoring
  with_rds_cloudwatch_alarms   = var.with_rds_cloudwatch_alarms
  cloudwatch_alarm_action_arns = var.cloudwatch_alarm_action_arns
}

# ***************************************
# Elasticache - Redis
# ***************************************
module "elasticache" {
  source = "./modules/elasticache"

  # VPC
  vpc_id              = module.vpc.vpc_id
  database_subnet_ids = module.vpc.database_subnet_ids

  # Redis
  redis_cluster_id                  = var.redis_cluster_id
  redis_single_node_cluster         = var.redis_single_node_cluster
  redis_engine_version              = var.redis_engine_version
  redis_ip_discovery                = var.redis_ip_discovery
  redis_log_delivery_configuration  = var.redis_log_delivery_configuration
  redis_network_type                = var.redis_network_type
  redis_node_type                   = var.redis_node_type
  redis_notification_topic_arn      = var.redis_notification_topic_arn
  redis_multi_az_enabled            = var.redis_multi_az_enabled
  redis_preferred_cache_cluster_azs = var.redis_preferred_cache_cluster_azs
  redis_replicas_per_node_group     = var.redis_replicas_per_node_group

  redis_apply_immediately          = var.redis_apply_immediately
  redis_auto_minor_version_upgrade = var.redis_auto_minor_version_upgrade
  redis_maintenance_window         = var.redis_maintenance_window

  redis_snapshot_arns            = var.redis_snapshot_arns
  redis_snapshot_name            = var.redis_snapshot_name
  redis_snapshot_retention_limit = var.redis_snapshot_retention_limit
  redis_snapshot_window          = var.redis_snapshot_window

  redis_transit_encryption_enabled = var.redis_transit_encryption_enabled
  redis_transit_encryption_mode    = var.redis_transit_encryption_mode
  redis_auth_token                 = var.redis_auth_token
  redis_at_rest_encryption_enabled = var.redis_at_rest_encryption_enabled
  redis_kms_key_arn                = var.redis_kms_key_arn
  redis_auth_token_update_strategy = var.redis_auth_token_update_strategy

  # Parameter group
  parameter_group_family     = var.parameter_group_family
  parameter_group_parameters = var.parameter_group_parameters

  # Tags
  redis_tags = var.redis_tags
}

# ***************************************
# Bastion
# ***************************************
module "bastion" {
  count = var.with_bastion ? 1 : 0

  source = "./modules/bastion"

  # AWS
  availability_zone = var.aws_availability_zones[0]

  # VPC
  vpc_id               = module.vpc.vpc_id
  vpc_public_subnet_id = module.vpc.public_subnets_ids[0]

  # Bastion
  bastion_ssh_key_name             = var.bastion_ssh_key_name
  bastion_whitelisted_access_cidrs = var.bastion_whitelisted_access_cidrs
  bastion_instance_type            = var.bastion_instance_type
  bastion_private_ip               = var.bastion_private_ip
  bastion_volume_type              = var.bastion_volume_type
  bastion_volume_size              = var.bastion_volume_size

  # Security Group
  rds_access_security_group_id   = module.rds.rds_access_security_group_id
  redis_access_security_group_id = module.elasticache.redis_access_security_group_id

  # Tags
  bastion_tags = var.bastion_tags
}

# ***************************************
# K8s deps
# ***************************************
module "k8s_deps" {
  source = "./modules/k8s_deps"

  aws_region        = var.aws_region
  vpc_id            = module.vpc.vpc_id
  whitelisted_cidrs = var.whitelisted_cidrs
  oidc_provider     = module.eks.oidc_provider
}
