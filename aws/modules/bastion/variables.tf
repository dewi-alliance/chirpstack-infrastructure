# ***************************************
# General
# ***************************************
variable "bastion_tags" {
  description = "Tags to be applied to all for Bastion"
  type        = map(string)
  default     = {}
}

variable "availability_zone" {
  description = "AWS availability zone for Bastion"
  type        = string
  default     = ""
}

# ***************************************
# VPC Info
# ***************************************
variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = ""
}

variable "vpc_public_subnet_id" {
  description = "Subnet ID of the public subnet to deploy Bastion into"
  type        = string
  default     = ""
}


# ***************************************
# Bastion
# ***************************************
variable "bastion_ssh_key_name" {
  description = "Name of ssh key to use to access Bastion"
  type        = string
  default     = ""
}

variable "bastion_whitelisted_access_ips" {
  description = "The IPs, in CIDR block form (x.x.x.x/32), to whitelist access to the Bastion"
  type        = list(string)
  default     = []
}

variable "bastion_instance_type" {
  description = "EC2 instance type for Bastion"
  type        = string
  default     = "t3.micro"
}

variable "bastion_private_ip" {
  description = "Private IP address to assign to Bastion"
  type        = string
  default     = "" # e.g., 10.0.1.5 AWS reserves first 4 addresses
}

variable "bastion_volume_type" {
  description = "EBS volume type for Bastion root volume"
  type        = string
  default     = "gp2"
}

variable "bastion_volume_size" {
  description = "EBS volume size for Bastion root volume"
  type        = string
  default     = "20"
}

# ***************************************
# Security Group
# ***************************************
variable "rds_access_security_group_id" {
  description = "The ID of the security group required to access the Chirpstack RDS instance"
  type        = string
  default     = ""
}

variable "redis_access_security_group_id" {
  description = "The ID of the security group required to access the Chirpstack Redis"
  type        = string
  default     = ""
}
