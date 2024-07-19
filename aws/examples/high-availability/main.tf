locals {
  aws_region         = "us-east-1"
  availability_zones = ["us-east-1a", "us-east-1b"]
}

# ***************************************
# VPC
# ***************************************
module "vpc" {
  source = "../../modules/vpc"

  # AWS
  availability_zones = local.availability_zones

  # VPC
  vpc_name       = "chirpstack-ha-vpc"
  vpc_cidr_block = "10.0.0.0/16"

  # Subnets
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]

  # Tags
  public_subnet_tags = {
    "kubernetes.io/cluster/chirpstack_cluster" = "shared"
    "kubernetes.io/role/elb"                   = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/chirpstack_cluster" = "shared"
    "kubernetes.io/role/internal-elb"          = 1
  }
}

# ***************************************
# EKS
# ***************************************
module "eks" {
  source = "../../modules/eks"

  # VPC
  vpc_id                 = module.vpc.vpc_id
  vpc_private_subnet_ids = module.vpc.private_subnets_ids

  # EKS
  eks_cluster_name    = "chirpstack-ha-cluster"
  eks_cluster_version = 1.29

  # EKS Node Group
  node_group_min_size     = 2
  node_group_max_size     = 6
  node_group_desired_size = 2
}

# ***************************************
# RDS
# ***************************************
module "rds" {
  source = "../../modules/rds"

  # AWS
  aws_region = local.aws_region

  # VPC
  vpc_id                   = module.vpc.vpc_id
  database_subnet_ids      = module.vpc.database_subnet_ids
  rds_db_subnet_group_name = module.vpc.database_subnet_group_name

  # RDS
  rds_name              = "chirpstack-ha-rds"
  rds_multi_az          = true
  with_rds_read_replica = true

  # DB
  pg_name           = "chirpstack"
  pg_engine_version = "14.10"
}

# ***************************************
# Elasticache - Redis
# ***************************************
module "elasticache" {
  source = "../../modules/elasticache"

  # AWS
  aws_region = local.aws_region

  # VPC
  vpc_id              = module.vpc.vpc_id
  database_subnet_ids = module.vpc.database_subnet_ids

  # Redis
  redis_cluster_id                  = "chirpstack-ha-redis"
  redis_single_node_cluster         = false
  redis_node_type                   = "cache.t4g.small"
  redis_multi_az_enabled            = true
  redis_preferred_cache_cluster_azs = local.availability_zones
  redis_replicas_per_node_group     = 1
  redis_maintenance_window          = "sun:05:00-sun:09:00"
  redis_snapshot_window             = "01:00-04:00"

  # Parameter group
  parameter_group_family = "redis7"
  parameter_group_parameters = [
    {
      name  = "latency-tracking"
      value = "yes"
    }
  ]
}

# ***************************************
# Bastion
# ***************************************
module "bastion" {
  source = "../../modules/bastion"

  # AWS
  availability_zone = local.availability_zones[0]

  # VPC
  vpc_id               = module.vpc.vpc_id
  vpc_public_subnet_id = module.vpc.public_subnets_ids[0]

  # Bastion
  bastion_ssh_key_name             = "name-of-your-ssh-key" # Create an SSH key and add the name here
  bastion_whitelisted_access_cidrs = ["0.0.0.0/0"]          # Insert CIDRs relevant to your access patterns
  bastion_private_ip               = "10.0.1.5"

  # Security Group
  rds_access_security_group_id   = module.rds.rds_access_security_group_id
  redis_access_security_group_id = module.elasticache.redis_access_security_group_id
}

# ***************************************
# K8s deps
# ***************************************
module "k8s_deps" {
  source = "../../modules/k8s_deps"

  aws_region        = local.aws_region
  whitelisted_cidrs = ["0.0.0.0/0"] # Insert CIDRs relevant to your access patterns

  vpc_id        = module.vpc.vpc_id
  oidc_provider = module.eks.oidc_provider
}
