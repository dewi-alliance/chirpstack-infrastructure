output "rds_id" {
  description = "The ID of the Chirpstack RDS instance"
  value       = try(aws_db_instance.rds.resource_id, null)
}

output "rds_access_security_group_id" {
  description = "The ID of the security group required to access the Chirpstack RDS instance"
  value       = try(aws_security_group.rds_access_security_group.id, null)
}

output "secrets_manager_rotator_lambda_security_group_id" {
  description = "Security group required for rotator Lambda to access Secrets Manager VPC endpoint"
  value       = try(aws_security_group.secrets_manager_rotator_lambda_security_group.id, null)
}
