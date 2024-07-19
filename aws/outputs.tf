output "bastion_public_ip" {
  description = "Public IP access of the Bastion"
  value       = module.bastion[0].public_ip
}

output "alb_security_group_id" {
  description = "Security Group ID for Application Load Balancer Security Group"
  value       = module.k8s_deps.alb_security_group_id
}

output "nlb_mqtt_security_group_id" {
  description = "Security Group ID for Network Load Balancer Security Group"
  value       = module.k8s_deps.nlb_mqtt_security_group_id
}
