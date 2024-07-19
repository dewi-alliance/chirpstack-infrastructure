output "alb_security_group_id" {
  description = "Security Group ID for Application Load Balancer Security Group"
  value       = aws_security_group.alb.id
}
output "nlb_mqtt_security_group_id" {
  description = "Security Group ID for Network Load Balancer Security Group"
  value       = aws_security_group.nlb_mqtt.id
}
