output "public_ip" {
  description = "Public IP access of the Bastion"
  value       = aws_eip.bastion_eip.public_ip
}
