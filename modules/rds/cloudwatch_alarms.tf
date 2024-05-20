# ***************************************
# CloudWatch Alarm
# CPU Utilization
# ***************************************
locals {
  cloudwatch_alarms = {
    cpu_utilization = {
      alarm_name          = "High CPU Utilization"
      alarm_description   = "Average Chirpstack RDS CPU utilization is above 80%."
      metric_name         = "CPUUtilization"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      namespace           = "AWS/RDS"
      period              = "60"
      statistic           = "Average"
      threshold           = "80"
    }
    disk_queue_depth = {
      alarm_name          = "High Disk Queue Depth"
      alarm_description   = "Average Chirpstack RDS disk queue depth is above 64."
      metric_name         = "DiskQueueDepth"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      namespace           = "AWS/RDS"
      period              = "60"
      statistic           = "Average"
      threshold           = "64"
    }
    disk_free_storage_space = {
      alarm_name          = "Low Free Storage Space"
      alarm_description   = "Chirpstack RDS free storage space is below 10GB."
      metric_name         = "FreeStorageSpace"
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = "2"
      namespace           = "AWS/RDS"
      period              = "60"
      statistic           = "Average"
      threshold           = "10000000000" # 10 GB
    }
    write_iops = {
      alarm_name          = "High Write IOPS"
      alarm_description   = "Average Chirpstack RDS write IOPS are above 500."
      metric_name         = "WriteIOPS"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      namespace           = "AWS/RDS"
      period              = "60"
      statistic           = "Average"
      threshold           = "500"
    }
    read_iops = {
      alarm_name          = "High Read IOPS"
      alarm_description   = "Average Chirpstack RDS read IOPS are above 500."
      metric_name         = "ReadIOPS"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      namespace           = "AWS/RDS"
      period              = "60"
      statistic           = "Average"
      threshold           = "500"
    }
    write_throughput = {
      alarm_name          = "High Write Throughput"
      alarm_description   = "Average Chirpstack RDS write throughput is above 300 MB/s."
      metric_name         = "WriteThroughput"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      namespace           = "AWS/RDS"
      period              = "60"
      statistic           = "Average"
      threshold           = "300000000" # 300MB
    }
    read_throughput = {
      alarm_name          = "High Read Throughput"
      alarm_description   = "Average Chirpstack RDS read throughput is above 300 MB/s."
      metric_name         = "ReadThroughput"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      namespace           = "AWS/RDS"
      period              = "60"
      statistic           = "Average"
      threshold           = "300000000" # 300MB
    }
    write_latency = {
      alarm_name          = "High Write Latency"
      alarm_description   = "Average Chirpstack RDS write latency is above 150 ms."
      metric_name         = "WriteLatency"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      namespace           = "AWS/RDS"
      period              = "60"
      statistic           = "Average"
      threshold           = "0.15" # 150 ms
    }
    read_latency = {
      alarm_name          = "High Read Latency"
      alarm_description   = "Average Chirpstack RDS read latency is above 150 ms."
      metric_name         = "ReadLatency"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      namespace           = "AWS/RDS"
      period              = "60"
      statistic           = "Average"
      threshold           = "0.15" # 150 ms
    }
    memory_freeable = {
      alarm_name          = "Low Freeable Memory"
      alarm_description   = "Average Chirpstack RDS freeable memory is below 256MB."
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = "2"
      metric_name         = "FreeableMemory"
      namespace           = "AWS/RDS"
      period              = "60"
      statistic           = "Average"
      threshold           = "256000000" # 256 MB
    }
    memory_swap_usage = {
      alarm_name          = "High Swap Usage"
      alarm_description   = "Average Chirpstack RDS swap usage is above 256MB."
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      metric_name         = "SwapUsage"
      namespace           = "AWS/RDS"
      period              = "60"
      statistic           = "Average"
      threshold           = "256000000" # 256 MB
    }
    maximum_used_transaction_ids = {
      alarm_name          = "Max Use Transaction IDs"
      alarm_description   = "Nearing a possible critical transaction ID wraparound."
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      metric_name         = "MaximumUsedTransactionIDs"
      namespace           = "AWS/RDS"
      period              = "60"
      statistic           = "Average"
      threshold           = "1000000000" # 1 billion. Half of total.
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "rds" {
  for_each = tomap(local.cloudwatch_alarms)

  alarm_name          = "Chirpstack RDS - ${each.value.alarm_name}"
  alarm_description   = each.value.alarm_description
  metric_name         = each.value.metric_name
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold

  alarm_actions = var.cloudwatch_alarm_action_arns
  ok_actions    = var.cloudwatch_alarm_action_arns

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.rds.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_read_replica" {
  for_each = var.rds_read_replica ? tomap(local.cloudwatch_alarms) : {}

  alarm_name          = "Chirpstack RDS Read Replica - ${each.value.alarm_name}"
  alarm_description   = each.value.alarm_description
  metric_name         = each.value.metric_name
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold

  alarm_actions = var.cloudwatch_alarm_action_arns
  ok_actions    = var.cloudwatch_alarm_action_arns

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.rds_read_replica[0].identifier
  }
}
