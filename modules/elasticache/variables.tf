# ***************************************
# General
# ***************************************
variable "aws_region" {
  description = "AWS region you're deploying to e.g., us-east-1"
  type        = string
  default     = ""
}

variable "redis_tags" {
  description = "A map of tags to add to all Redis resources"
  type        = map(string)
  default     = {}
}

# ***************************************
# VPC Info
# ***************************************
variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = ""
}

variable "database_subnet_ids" {
  description = "Subnet IDs of the database subnet for creating Redis subnet group"
  type        = list(string)
  default     = []
}

# ***************************************
# Redis
# ***************************************
variable "redis_single_node_cluster" {
  description = "Whether to deploy a single cluster with a single node, or a multi-cluster with multiple nodes."
  type        = bool
  default     = null
}

variable "redis_apply_immediately" {
  description = "Whether any database modifications are applied immediately, or during the next maintenance window. Default is `false`"
  type        = bool
  default     = null
}

variable "redis_auto_minor_version_upgrade" {
  description = "Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Only supported for engine type `redis` and if the engine version is 6 or higher. Defaults to `true`"
  type        = bool
  default     = null
}

variable "redis_cluster_id" {
  description = "Group identifier. ElastiCache converts this name to lowercase. Changing this value will re-create the resource"
  type        = string
  default     = ""
}

variable "redis_engine_version" {
  description = "Version number of the Redis cache engine to be used. If not set, defaults to the latest version"
  type        = string
  default     = null
}

variable "redis_ip_discovery" {
  description = "The IP version to advertise in the discovery protocol. Valid values are `ipv4` or `ipv6`"
  type        = string
  default     = null
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
  description = "The IP versions for cache cluster connections. Valid values are `ipv4`, `ipv6` or `dual_stack`"
  type        = string
  default     = null
}

variable "redis_node_type" {
  description = "The instance class used. For Memcached, changing this value will re-create the resource"
  type        = string
  default     = null
}

variable "redis_notification_topic_arn" {
  description = "ARN of an SNS topic to send ElastiCache notifications to"
  type        = string
  default     = null
}

variable "redis_snapshot_arns" {
  description = "Single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3"
  type        = list(string)
  default     = []
}

variable "redis_snapshot_name" {
  description = "Name of a snapshot from which to restore data into the new node group. Changing `snapshot_name` forces a new resource"
  type        = string
  default     = null
}

variable "redis_snapshot_retention_limit" {
  description = "Number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them"
  type        = number
  default     = null
}

variable "redis_snapshot_window" {
  description = "Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. Example: `05:00-09:00`"
  type        = string
  default     = null
}

variable "redis_transit_encryption_enabled" {
  description = "Enable encryption in-transit. Supported only with Memcached versions `1.6.12` and later, running in a VPC"
  type        = bool
  default     = true
}

variable "redis_transit_encryption_mode" {
  description = "A setting that enables clients to migrate to in-transit encryption with no downtime. Valid values are preferred and required"
  type        = string
  default     = null
}

################################################################################
# Replication Group
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
  description = "Whether to enable encryption at rest"
  type        = bool
  default     = true
}

variable "redis_kms_key_arn" {
  description = "The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if `at_rest_encryption_enabled = true`"
  type        = string
  default     = null
}

variable "redis_multi_az_enabled" {
  description = "Specifies whether to enable Multi-AZ Support for the replication group. If true, `automatic_failover_enabled` must also be enabled. Defaults to `false`"
  type        = bool
  default     = false
}

variable "redis_preferred_cache_cluster_azs" {
  description = "List of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is considered. The first item in the list will be the primary node. Ignored when updating"
  type        = list(string)
  default     = []
}

variable "redis_replicas_per_node_group" {
  description = "Number of replica nodes in each node group. Changing this number will trigger a resizing operation before other settings modifications. Valid values are 0 to 5"
  type        = number
  default     = null
}

# ***************************************
# Parameter Group
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
