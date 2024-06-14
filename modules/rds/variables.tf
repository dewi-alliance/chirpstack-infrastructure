# ***************************************
# General
# ***************************************
variable "aws_region" {
  description = "AWS region you're deploying to e.g., us-east-1"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "ID of VPC for RDS security group"
  type        = string
  default     = ""
}

variable "database_subnet_ids" {
  description = "List of database subnet IDs"
  type        = list(string)
  default     = []
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
  description = "Create a final DB snapshot before the DB instance is deleted? If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from rds_name. Default is false."
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

variable "rds_db_subnet_group_name" {
  description = "Name of database subnet group"
  type        = string
  default     = ""
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

# ***************************************
# Postgres
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
  default     = ""
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
# IAM Role
# ***************************************
variable "oidc_provider" {
  description = "EKS OIDC provider name to enable K8s pods to assume IAM role to access RDS"
  type        = string
  default     = ""
}

variable "oidc_provider_arn" {
  description = "EKS OIDC provider arn to enable K8s pods to assume IAM role to access RDS"
  type        = string
  default     = ""
}

# ***************************************
# Cloudwatch Alerting
# ***************************************
variable "with_rds_cloudwatch_alarms" {
  description = "Deploy Cloudwatch Alarms for RDS?"
  type        = bool
  default     = false
}

variable "cloudwatch_alarm_action_arns" {
  description = "CloudWatch Alarm Action ARNs to report CloudWatch Alarms"
  type        = list(string)
  default     = []
}
