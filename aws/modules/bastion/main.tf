# ***************************************
# Module Data
# ***************************************
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# ***************************************
# EC2
# ***************************************
resource "aws_instance" "this" {
  # Instance
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.bastion_instance_type
  key_name      = var.bastion_ssh_key_name

  # VPC & Networking
  availability_zone = var.availability_zone
  subnet_id         = var.vpc_public_subnet_id
  private_ip        = var.bastion_private_ip

  # Security
  vpc_security_group_ids = concat(
    [aws_security_group.this.id],
    [
      var.rds_access_security_group_id,
      var.redis_access_security_group_id
    ]
  )

  # Storage
  root_block_device {
    volume_type           = var.bastion_volume_type
    volume_size           = var.bastion_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  # User data
  user_data                   = file("${path.module}/scripts/user_data.sh")
  user_data_replace_on_change = true

  tags = merge(
    {
      Name = "bastion"
    },
    var.bastion_tags
  )
}

# ***************************************
# Security Group
# ***************************************
locals {
  bastion_security_group_rules = {
    ingress_ssh_22 = {
      type        = "ingress"
      description = "Allow SSH access from whitelisted IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.bastion_whitelisted_access_cidrs
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

resource "aws_security_group" "this" {
  name        = "bastion-security-group"
  description = "Security group restricting access to Bastion"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "bastion-security-group"
    },
    var.bastion_tags
  )
}

resource "aws_security_group_rule" "this" {
  for_each = { for k, v in merge(
    local.bastion_security_group_rules,
  ) : k => v }

  # Required
  security_group_id = aws_security_group.this.id
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
# Elastic IP
# ***************************************
resource "aws_eip" "bastion_eip" {
  domain                    = "vpc"
  instance                  = aws_instance.this.id
  associate_with_private_ip = var.bastion_private_ip

  tags = merge(
    {
      Name = "bastion"
    },
    var.bastion_tags,
  )
}
