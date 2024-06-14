# ***************************************
# Module Data
# ***************************************
data "aws_caller_identity" "current" {}

# ***************************************
# Redis
# ***************************************
resource "random_string" "redis" {
  length  = 8
  special = false
}

resource "aws_elasticache_replication_group" "this" {
  engine                 = "redis"
  description            = "Chirpstack Redis Replication group"
  node_type              = var.redis_node_type
  engine_version         = var.redis_engine_version
  notification_topic_arn = var.redis_notification_topic_arn
  parameter_group_name   = aws_elasticache_parameter_group.this.name

  apply_immediately          = var.redis_apply_immediately
  auto_minor_version_upgrade = var.redis_auto_minor_version_upgrade
  maintenance_window         = var.redis_maintenance_window

  network_type       = var.redis_network_type
  security_group_ids = [aws_security_group.redis_security_group.id]
  subnet_group_name  = aws_elasticache_subnet_group.this.name
  ip_discovery       = var.redis_ip_discovery
  port               = 6379

  at_rest_encryption_enabled = var.redis_at_rest_encryption_enabled
  auth_token                 = var.redis_auth_token
  auth_token_update_strategy = var.redis_auth_token_update_strategy
  kms_key_id                 = var.redis_at_rest_encryption_enabled ? var.redis_kms_key_arn : null
  transit_encryption_enabled = var.redis_transit_encryption_enabled
  transit_encryption_mode    = var.redis_transit_encryption_mode

  final_snapshot_identifier = "chirpstack-redis-final-snapshot-${random_string.redis.result}"
  snapshot_arns             = var.redis_snapshot_arns
  snapshot_name             = var.redis_snapshot_name
  snapshot_retention_limit  = var.redis_snapshot_retention_limit
  snapshot_window           = var.redis_snapshot_window

  automatic_failover_enabled  = var.redis_multi_az_enabled
  multi_az_enabled            = var.redis_multi_az_enabled
  preferred_cache_cluster_azs = var.redis_preferred_cache_cluster_azs
  replicas_per_node_group     = var.redis_single_node_cluster ? 0 : var.redis_replicas_per_node_group
  replication_group_id        = var.redis_cluster_id

  user_group_ids = [aws_elasticache_user_group.this.user_group_id]

  dynamic "log_delivery_configuration" {
    for_each = var.redis_log_delivery_configuration

    content {
      destination      = log_delivery_configuration.value.destination_type == "cloudwatch-logs" ? aws_cloudwatch_log_group.this[log_delivery_configuration.key].name : log_delivery_configuration.value.destination
      destination_type = log_delivery_configuration.value.destination_type
      log_format       = log_delivery_configuration.value.log_format
      log_type         = try(log_delivery_configuration.value.log_type, log_delivery_configuration.key)
    }
  }

  tags = var.redis_tags
}

# ***************************************
# Redis Subnet Group
# ***************************************
resource "aws_elasticache_subnet_group" "this" {
  name        = "${var.redis_cluster_id}-subnet-group"
  description = "Chirpstack Redis subnet group"
  subnet_ids  = var.database_subnet_ids

  tags = var.redis_tags
}

# ***************************************
# Redis Parameter Group
# ***************************************
resource "aws_elasticache_parameter_group" "this" {
  name        = "${var.redis_cluster_id}-parameter-group"
  description = "Chirpstack Redis parameter group"
  family      = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.parameter_group_parameters

    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.redis_tags
}

# ***************************************
# Redis Cloudwatch Log Group
# ***************************************
resource "aws_cloudwatch_log_group" "this" {
  for_each = { for k, v in var.redis_log_delivery_configuration : k => v if try(v.destination_type, "") == "cloudwatch-logs" }

  name              = "/aws/elasticache/${each.key}"
  retention_in_days = 90

  tags = var.redis_tags
}

# ***************************************
# Security Group
# Redis Security Group
# ***************************************
locals {
  chirpstack_redis_security_group_rules = {
    ingress_redis_access_sg_6379 = {
      type                     = "ingress"
      description              = "Allow access from redis-access-security-group"
      from_port                = 6379
      to_port                  = 6379
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.redis_access_security_group.id
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

resource "aws_security_group" "redis_security_group" {
  name        = "redis-security-group"
  description = "Security group for Chirpstack Redis cluster"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "redis-security-group"
    },
    var.redis_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "redis_security_group_rule" {
  for_each = { for k, v in merge(
    local.chirpstack_redis_security_group_rules,
  ) : k => v }

  # Required
  security_group_id = aws_security_group.redis_security_group.id
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
# Redis Access security group
# ***************************************
resource "aws_security_group" "redis_access_security_group" {
  name        = "redis-access-security-group"
  description = "Security group required to access Chirpstack Redis cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-access-security-group"
  }
}

# ***************************************
# Redis Users
# ***************************************

resource "aws_elasticache_user_group" "this" {
  engine        = "REDIS"
  user_group_id = "chirpstack"
  user_ids      = [aws_elasticache_user.default.user_id]

  lifecycle {
    ignore_changes = [user_ids]
  }

  tags = var.redis_tags
}

resource "aws_elasticache_user" "default" {
  engine        = "REDIS"
  access_string = "on ~* +@all"
  passwords     = [random_password.redis_default_password.result]
  user_id       = "defaultuserid"
  user_name     = "default"

  tags = var.redis_tags
}

resource "aws_elasticache_user" "chirpstack" {
  engine        = "REDIS"
  access_string = "on ~* +@all -@dangerous -@admin"
  passwords     = [random_password.redis_chirpstack_password.result]
  user_id       = "chirpstackuserid"
  user_name     = "chirpstack"

  tags = var.redis_tags
}

resource "aws_elasticache_user_group_association" "chirpstack" {
  user_group_id = aws_elasticache_user_group.this.user_group_id
  user_id       = aws_elasticache_user.chirpstack.user_id
}
