# ***************************************
# Redis - Single Node Cluster
# ***************************************
resource "aws_elasticache_cluster" "single_node_cluster" {
  count = var.redis_single_node_cluster ? 1 : 0

  engine                 = "redis"
  num_cache_nodes        = 1
  cluster_id             = var.redis_cluster_id
  node_type              = var.redis_node_type
  availability_zone      = var.redis_availability_zone
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

  final_snapshot_identifier = var.redis_final_snapshot_identifier
  snapshot_arns             = var.redis_snapshot_arns
  snapshot_name             = var.redis_snapshot_name
  snapshot_retention_limit  = var.redis_snapshot_retention_limit
  snapshot_window           = var.redis_snapshot_window

  dynamic "log_delivery_configuration" {
    for_each = tomap(var.redis_log_delivery_configuration)

    content {
      destination      = each.value.destination_type == "cloudwatch-logs" ? aws_cloudwatch_log_group.this[each.key].name : each.value.destination
      destination_type = each.value.destination_type
      log_format       = each.value.log_format
      log_type         = try(each.value.log_type, each.key)
    }
  }

  tags = var.redis_tags
}

# ***************************************
# Redis - Multi Node Cluster
# ***************************************
resource "aws_elasticache_replication_group" "this" {
  count = !var.redis_single_node_cluster ? 1 : 0

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

  final_snapshot_identifier = var.redis_final_snapshot_identifier
  snapshot_arns             = var.redis_snapshot_arns
  snapshot_name             = var.redis_snapshot_name
  snapshot_retention_limit  = var.redis_snapshot_retention_limit
  snapshot_window           = var.redis_snapshot_window

  automatic_failover_enabled  = var.redis_multi_az_enabled
  multi_az_enabled            = var.redis_multi_az_enabled
  num_cache_clusters          = var.redis_num_cache_clusters
  num_node_groups             = var.redis_num_node_groups
  preferred_cache_cluster_azs = var.redis_preferred_cache_cluster_azs
  replicas_per_node_group     = var.redis_replicas_per_node_group
  replication_group_id        = var.redis_cluster_id

  user_group_ids = var.redis_user_group_ids

  dynamic "log_delivery_configuration" {
    for_each = tomap(var.redis_log_delivery_configuration)

    content {
      destination      = each.value.destination_type == "cloudwatch-logs" ? aws_cloudwatch_log_group.this[each.key].name : each.value.destination
      destination_type = each.value.destination_type
      log_format       = each.value.log_format
      log_type         = try(each.value.log_type, each.key)
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
  subnet_ids  = var.vpc_database_subnet_ids

  tags = var.redis_tags
}

# ***************************************
# Redis Parameter Group
# ***************************************
resource "aws_elasticache_parameter_group" "this" {
  name        = "${var.redis_cluster_id}-parameter-group"
  description = "Chirpstack Redis parameter group"
  family      = var.redis_parameter_group_family

  dynamic "parameter" {
    for_each = toset(var.redis_parameter_group_parameters)

    content {
      name  = each.value.name
      value = each.value.value
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

  name              = "/aws/elasticache/${each.value.key}"
  retention_in_days = 90

  tags = var.redis_tags
}

# ***************************************
# Security Group
# Redis Security Group
# ***************************************
locals {
  chirpstack_redis_security_group_rules = {
    ingress_rds_access_sg_5432 = {
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
  description = "Security group for Chirpstack Redis resource"
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
