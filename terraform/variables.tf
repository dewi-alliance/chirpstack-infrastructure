# ***************************************
# AWS
# ***************************************
variable "aws_region" {
  description = "AWS region for infrastructure."
  type        = string
  default     = ""
}

variable "aws_availability_zones" {
  description = "A list AWS availability zones for the VPC."
  type        = list(string)
  default     = []
}

# ***************************************
# VPC
# ***************************************
variable "vpc_name" {
  description = "The name of the VPC. Defaults to chirpstack-vpc."
  type        = string
  default     = "chirpstack-vpc"
}

variable "vpc_cidr_block" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = ""
}

variable "vpc_enable_dns_support" {
  description = "Enable DNS support in the VPC? Defaults to true."
  type        = bool
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC. Defaults true."
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Tags to be applied to all resources in the VPC."
  type        = map(string)
  default     = {}
}


# ***************************************
# VPC - Public Subnets
# ***************************************
variable "public_subnets" {
  description = "A list of IPv4 CIDR blocks for public subnets inside the VPC."
  type        = list(string)
  default     = []
}

variable "public_subnet_tags" {
  description = "Tags for public subnets."
  type        = map(string)
  default     = {}
}

# ***************************************
# VPC - Private Subnets
# ***************************************
variable "private_subnets" {
  description = "A list of IPv4 CIDR blocks for private subnets inside the VPC."
  type        = list(string)
  default     = []

}

variable "private_subnet_tags" {
  description = "Tags for private subnets."
  type        = map(string)
  default     = {}
}

# ***************************************
# VPC - Database Subnets
# ***************************************
variable "database_subnets" {
  description = "A list of IPv4 CIDR blocks for database subnets inside the VPC."
  type        = list(string)
  default     = []
}

# ***************************************
# VPC - NAT Gateway
# ***************************************
variable "single_nat_gateway" {
  description = "Use single NAT gateway for cost savings (otherwise NAT gateways will be created per AZ)? Defaults to false."
  type        = bool
  default     = false
}

# ***************************************
# EKS Cluster
# ***************************************
variable "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = ""
}

variable "eks_cluster_version" {
  description = "Version of the EKS Cluster"
  type        = string
  default     = ""
}

variable "eks_log_types" {
  description = "A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
  default     = ["audit", "api", "authenticator", "controllerManager", "scheduler"]
}

variable "eks_authentication_mode" {
  description = "The authentication mode for the cluster. Valid values are `CONFIG_MAP`, `API` or `API_AND_CONFIG_MAP`"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

variable "eks_bootstrap_cluster_creator_admin_permissions" {
  description = "Bootstrap the access config values to the cluster? For more information, see Amazon EKS Access Entries (https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html)"
  type        = bool
  default     = true
}

variable "eks_endpoint_private_access" {
  description = "Enable the Amazon EKS private API server endpoint?"
  type        = bool
  default     = false
}

variable "eks_endpoint_public_access" {
  description = "Enable the Amazon EKS public API server endpoint?"
  type        = bool
  default     = true
}

variable "eks_tags" {
  description = "Additional tags for all resources related to EKS"
  type        = map(string)
  default     = {}
}

# ***************************************
# EKS - KMS Key for EKS Secret Encryption
# ***************************************
variable "kms_key_usage" {
  description = "Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT, SIGN_VERIFY, or GENERATE_VERIFY_MAC"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "kms_enable_key_rotation" {
  description = "Enable KMS key rotation?. For more information, see Rotating KMS Keys (https://docs.aws.amazon.com/kms/latest/developerguide/rotate-keys.html)"
  type        = bool
  default     = true
}

# ***************************************
# EKS - CloudWatch Log Group for EKS Control Plane logging
# ***************************************
variable "cloudwatch_retention_in_days" {
  description = "Duration to retain EKS control plane logs"
  type        = number
  default     = 90
}

# ***************************************
#  EKS - EKS Addons
# ***************************************
variable "eks_addon_preserve" {
  description = "Preserve the created add-on resources in the cluster when deleting the EKS add-on?"
  type        = bool
  default     = false
}

variable "eks_addon_resolve_conflicts_on_update" {
  description = "How to resolve field value conflicts for an Amazon EKS add-on if you've changed a value from the Amazon EKS default value. Valid values are NONE, OVERWRITE, and PRESERVE. For more information, see the UpdateAddon API Docs (https://docs.aws.amazon.com/eks/latest/APIReference/API_UpdateAddon.html)"
  type        = string
  default     = "OVERWRITE"
}

variable "eks_vpc_cni_version" {
  description = "Version of the VPC CNI cluster addon"
  type        = string
  default     = null
}

variable "eks_coredns_version" {
  description = "Version of the Coredns cluster addon"
  type        = string
  default     = null
}

variable "eks_kube_proxy_version" {
  description = "Version of the Kube-Proxy cluster addon"
  type        = string
  default     = null
}

# ***************************************
#  EKS - aws-auth configmap
# ***************************************
# variable "eks_aws_auth_roles" {
#   description = "List of role maps to add to the aws-auth configmap"
#   type        = list(any)
#   default     = []
# }

# variable "eks_aws_auth_users" {
#   description = "List of user maps to add to the aws-auth configmap"
#   type        = list(any)
#   default     = []
# }

# variable "eks_aws_auth_accounts" {
#   description = "List of account maps to add to the aws-auth configmap"
#   type        = list(any)
#   default     = []
# }

# ***************************************
# EKS - Node Group
# ***************************************
variable "node_group_min_size" {
  description = "Minimum number of nodes in EKS cluster"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in EKS cluster"
  type        = number
  default     = 1
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in EKS cluster"
  type        = number
  default     = 1
}

variable "node_group_ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. See the [AWS documentation](https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType) for valid values"
  type        = string
  default     = "AL2_x86_64"
}

variable "node_group_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_group_disk_size" {
  description = "Disk size in GiB for nodes. Defaults to `20`."
  type        = number
  default     = null
}

variable "node_group_instance_types" {
  description = "Set of instance types associated with the EKS Node Group. Defaults to `[\"m5.large\"]`"
  type        = list(string)
  default     = ["m5.large"]
}

variable "node_group_max_unavailable_percentage" {
  description = "Desired max percentage of unavailable worker nodes during node group update."
  type        = number
  default     = 33
}

# ***************************************
# RDS
# ***************************************
variable "rds_name" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier."
  type        = string
  default     = ""
}

variable "rds_storage_type" {
  description = "EBS storage type for RDS e.g., gp3"
  type        = string
  default     = "gp3"
}

variable "rds_storage_size" {
  description = "EBS storage size for RDS"
  type        = number
  default     = 100
}

variable "rds_max_storage_size" {
  description = "Maximum EBS storage size for RDS"
  type        = number
  default     = 1000
}

variable "rds_instance_type" {
  description = "Instance type for RDS"
  type        = string
  default     = "db.m6i.large"
}

variable "rds_storage_encrypted" {
  description = "Encrypt the DB instance?"
  type        = bool
  default     = true
}

variable "rds_skip_final_snapshot" {
  description = "Skip taking a final DB snapshot before the DB instance is deleted? If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from rds_name. Default is false."
  type        = bool
  default     = false
}

variable "rds_backup_retention_period" {
  description = "The days to retain backups for. Must be between 0 and 35. Default is 0. Must be greater than 0 if the database is used as a source for a Read Replica. Default is 30."
  type        = number
  default     = 30
}

variable "rds_db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "rds_iam_database_authentication_enabled" {
  description = "Enable IAM database authentication?"
  type        = bool
  default     = true
}

variable "rds_deploy_from_snapshot" {
  description = "Deploy RDS from snapshot?"
  type        = bool
  default     = false
}

variable "rds_snapshot_identifier" {
  description = "Snapshot identifier for restoration from snapshot. Requires rds_deploy_from_snapshot to be true."
  type        = string
  default     = ""
}

variable "rds_multi_az" {
  description = "Multi-az deployment?"
  type        = bool
  default     = false
}

variable "with_rds_read_replica" {
  description = "Create read replica of primary DB?"
  type        = bool
  default     = false
}

variable "with_rds_cloudwatch_alarms" {
  description = "Deploy Cloudwatch Alarms for RDS?"
  type        = bool
  default     = false
}

# ***************************************
# RDS - Postgres
# ***************************************
variable "pg_name" {
  description = "Postgres database name"
  type        = string
  default     = ""
}

variable "pg_engine_version" {
  description = "Postgres database engine version. Defaults to 14.10, used by Chirpstack."
  type        = string
  default     = "14.10"
}

variable "pg_ssl_required" {
  description = "Require SSL to connect to database?"
  type        = bool
  default     = true
}

variable "pg_username" {
  description = "Postgres admin username"
  type        = string
  default     = "chirpstack_admin"
}

variable "pg_log_exports" {
  description = "Enable CloudWatch log exports"
  type        = list(string)
  default     = ["postgresql"]
}

variable "pg_family" {
  description = "Postgres family for parameter group for mandating SSL. Defaults to postgres14 used by Chirpstack."
  type        = string
  default     = "postgres14"
}

# ***************************************
# Redis
# ***************************************
variable "redis_single_node_cluster" {
  description = "Deploy a single cluster with a single node (otherwise a multi-cluster with multiple nodes is created)? Default is `true`"
  type        = bool
  default     = true
}

variable "redis_apply_immediately" {
  description = "Apply database modifications immediately (or during the next maintenance window)? Default is `false`"
  type        = bool
  default     = false
}

variable "redis_auto_minor_version_upgrade" {
  description = "Apply minor version engine upgrades automatically to the underlying Cache Cluster instances during the maintenance window? Only supported for engine type `redis` and if the engine version is 6 or higher. Defaults to `true`"
  type        = bool
  default     = true
}

variable "redis_cluster_id" {
  description = "Cluster name. ElastiCache converts this name to lowercase. Changing this value will re-create the resource"
  type        = string
  default     = ""
}

variable "redis_engine_version" {
  description = "Version number of the Redis cache engine to be used. If not set, defaults to the latest version"
  type        = string
  default     = null
}

variable "redis_ip_discovery" {
  description = "The IP version to advertise in the discovery protocol. Valid values are `ipv4` or `ipv6`. Default is `ipv4`"
  type        = string
  default     = "ipv4"
}

variable "redis_log_delivery_configuration" {
  description = "Specifies the destination and format of Redis SLOWLOG or Redis Engine Log"
  type        = any
  default = {
    slow-log = {
      destination_type = "cloudwatch-logs"
      log_format       = "json"
    }
    engine-log = {
      destination_type = "cloudwatch-logs"
      log_format       = "json"
    }
  }
}

variable "redis_maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is `ddd:hh24:mi-ddd:hh24:mi` (24H Clock UTC)"
  type        = string
  default     = null
}

variable "redis_network_type" {
  description = "The IP versions for cache cluster connections. Valid values are `ipv4`, `ipv6` or `dual_stack`. Default is `ipv4`."
  type        = string
  default     = "ipv4"
}

variable "redis_node_type" {
  description = "The instance class used. For Memcached, changing this value will re-create the resource"
  type        = string
  default     = null
}

variable "redis_notification_topic_arn" {
  description = "ARN of an SNS topic to send ElastiCache notifications"
  type        = string
  default     = null
}

variable "redis_snapshot_arns" {
  description = "To restore from snapshot - single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3"
  type        = list(string)
  default     = []
}

variable "redis_snapshot_name" {
  description = "To restore from snapshot - name of a snapshot from which to restore data into the new node group. Changing `snapshot_name` forces a new resource"
  type        = string
  default     = null
}

variable "redis_snapshot_retention_limit" {
  description = "Number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. Default is `5`."
  type        = number
  default     = 5
}

variable "redis_snapshot_window" {
  description = "Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. Example: `05:00-09:00`"
  type        = string
  default     = null
}

variable "redis_transit_encryption_enabled" {
  description = "Enable encryption in-transit? Default is `true`."
  type        = bool
  default     = true
}

variable "redis_transit_encryption_mode" {
  description = "A setting that enables clients to migrate to in-transit encryption with no downtime. Valid values are preferred and required"
  type        = string
  default     = null
}

################################################################################
# Redis - Replication Group
################################################################################
variable "redis_auth_token" {
  description = "The password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true`"
  type        = string
  default     = null
}

variable "redis_auth_token_update_strategy" {
  description = "Strategy to use when updating the `auth_token`. Valid values are `SET`, `ROTATE`, and `DELETE`. Defaults to `ROTATE`"
  type        = string
  default     = null
}

variable "redis_at_rest_encryption_enabled" {
  description = "Enable encryption at rest?"
  type        = bool
  default     = true
}

variable "redis_kms_key_arn" {
  description = "The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if `at_rest_encryption_enabled = true`"
  type        = string
  default     = null
}

variable "redis_multi_az_enabled" {
  description = "In multi-node clusters, enable Multi-AZ Support for the replication group? If true, `automatic_failover_enabled` must also be enabled. Defaults to `false`"
  type        = bool
  default     = false
}

variable "redis_preferred_cache_cluster_azs" {
  description = "In multi-node clusters, list of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is considered. The first item in the list will be the primary node. Ignored when updating"
  type        = list(string)
  default     = []
}

variable "redis_replicas_per_node_group" {
  description = "In multi-node clusters, number of replica nodes in each node group. Changing this number will trigger a resizing operation before other settings modifications. Valid values are 0 to 5"
  type        = number
  default     = null
}

variable "redis_tags" {
  description = "A map of tags to add to all Redis resources"
  type        = map(string)
  default     = {}
}

# ***************************************
# Redis - Parameter Group
# ***************************************
variable "parameter_group_family" {
  description = "The family of the ElastiCache parameter group"
  type        = string
  default     = ""
}

variable "parameter_group_parameters" {
  description = "List of ElastiCache parameters to apply"
  type        = list(map(string))
  default     = []
}

# ***************************************
# Cloudwatch Alerting
# ***************************************
variable "cloudwatch_alarm_action_arns" {
  description = "CloudWatch Alarm Action ARNs to report CloudWatch Alarms"
  type        = list(string)
  default     = []
}

# ***************************************
# Bastion
# ***************************************
variable "with_bastion" {
  description = "Should Bastion be created?"
  type        = bool
  default     = false
}

variable "bastion_ssh_key_name" {
  description = "Name of ssh key to use to access Bastion"
  type        = string
  default     = ""
}

variable "bastion_whitelisted_access_ips" {
  description = "The IPs, in CIDR block form (x.x.x.x/32), to whitelist access to the Bastion"
  type        = list(string)
  default     = []
}

variable "bastion_instance_type" {
  description = "EC2 instance type for Bastion"
  type        = string
  default     = "t3.micro"
}

variable "bastion_private_ip" {
  description = "Private IP address to assign to Bastion"
  type        = string
  default     = "" # e.g., 10.0.1.5 AWS reserves first 4 addresses
}

variable "bastion_volume_type" {
  description = "EBS volume type for Bastion root volume"
  type        = string
  default     = "gp2"
}

variable "bastion_volume_size" {
  description = "EBS volume size for Bastion root volume"
  type        = string
  default     = "20"
}

variable "bastion_tags" {
  description = "Tags to be applied to all for Bastion"
  type        = map(string)
  default     = {}
}
