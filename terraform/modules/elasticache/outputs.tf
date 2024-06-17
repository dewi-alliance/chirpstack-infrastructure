output "redis_access_security_group_id" {
  description = "The ID of the security group required to access Redis"
  value       = try(aws_security_group.redis_access_security_group.id, null)
}
