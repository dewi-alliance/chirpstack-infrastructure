# ***************************************
# Module Data
# ***************************************
data "aws_partition" "current" {}

data "aws_serverlessapplicationrepository_application" "rotator" {
  application_id = "arn:aws:serverlessrepo:us-east-1:297356227824:applications/SecretsManagerRDSPostgreSQLRotationSingleUser"
}

# ***************************************
# RDS
# ***************************************
resource "random_string" "rds" {
  length  = 8
  special = false
}

resource "aws_db_instance" "rds" {
  identifier                          = var.rds_name
  storage_type                        = var.rds_storage_type
  allocated_storage                   = var.rds_storage_size
  max_allocated_storage               = var.rds_max_storage_size
  instance_class                      = var.rds_instance_type
  storage_encrypted                   = var.rds_storage_encrypted
  iam_database_authentication_enabled = var.rds_iam_database_authentication_enabled
  multi_az                            = var.rds_multi_az

  port                   = var.rds_db_port
  db_subnet_group_name   = var.rds_db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  skip_final_snapshot       = var.rds_skip_final_snapshot
  final_snapshot_identifier = !var.rds_skip_final_snapshot ? "${var.rds_name}-final-snap-${random_string.rds.result}" : null
  backup_retention_period   = var.rds_backup_retention_period
  snapshot_identifier       = var.rds_deploy_from_snapshot ? var.rds_snapshot_identifier : null

  db_name                         = var.pg_name
  engine                          = "postgres"
  engine_version                  = var.pg_engine_version
  username                        = var.pg_username
  password                        = random_password.pg_admin_password.result
  parameter_group_name            = var.pg_ssl_required ? aws_db_parameter_group.this[0].name : null
  enabled_cloudwatch_logs_exports = var.pg_log_exports
}

# ***************************************
# RDS - Read Replica
# ***************************************
resource "aws_db_instance" "rds_read_replica" {
  count = var.with_rds_read_replica ? 1 : 0

  replicate_source_db = aws_db_instance.rds.identifier

  identifier                      = "${var.rds_name}-read-replica"
  enabled_cloudwatch_logs_exports = var.pg_log_exports

  port                                = var.rds_db_port
  vpc_security_group_ids              = [aws_security_group.rds_security_group.id]
  iam_database_authentication_enabled = var.rds_iam_database_authentication_enabled

  storage_type            = var.rds_storage_type
  allocated_storage       = var.rds_storage_size
  max_allocated_storage   = var.rds_max_storage_size
  instance_class          = var.rds_instance_type
  storage_encrypted       = var.rds_storage_encrypted
  backup_retention_period = var.rds_backup_retention_period
  skip_final_snapshot     = true
}

# ***************************************
# RDS Parameter Group
# Custom group to force SSL connections to Postgres database
# ***************************************
resource "aws_db_parameter_group" "this" {
  count = var.pg_ssl_required ? 1 : 0

  name        = "pg-parameter-group"
  description = "Postgres parameter group forcing SSL"
  family      = var.pg_family

  parameter {
    name  = "rds.force_ssl"
    value = 1
  }
}

# ***************************************
# Security Group
# RDS security group
# ***************************************
locals {
  rds_security_group_rules = {
    ingress_rds_access_sg_5432 = {
      type                     = "ingress"
      description              = "Allow access from rds-access-security-group"
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.rds_access_security_group.id
    }
    ingress_lamba_sg_5432 = {
      type                     = "ingress"
      description              = "Allow access from secrets-manager-access-security-group"
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.secrets_manager_access_security_group.id
    }
    egress_all = {
      description = "Allow all egress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_security_group" "rds_security_group" {
  name        = "rds-security-group"
  description = "Security group for Chirpstack RDS resource"
  vpc_id      = var.vpc_id

  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_security_group_rule" "rds_security_group_rule" {
  for_each = { for k, v in merge(
    local.rds_security_group_rules,
  ) : k => v }

  # Required
  security_group_id = aws_security_group.rds_security_group.id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type
  description       = each.value.description

  # Optional
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}

# ***************************************
# Security Group
# RDS Access security group
# ***************************************
resource "aws_security_group" "rds_access_security_group" {
  name        = "rds-access-security-group"
  description = "Security group required to access Chirpstack RDS instance"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-access-security-group"
  }
}
