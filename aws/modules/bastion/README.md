<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.50.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.bastion_eip](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/eip) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/instance) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.this](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group_rule) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | AWS availability zone for Bastion | `string` | `""` | no |
| <a name="input_bastion_instance_type"></a> [bastion\_instance\_type](#input\_bastion\_instance\_type) | EC2 instance type for Bastion | `string` | `"t3.micro"` | no |
| <a name="input_bastion_private_ip"></a> [bastion\_private\_ip](#input\_bastion\_private\_ip) | Private IP address to assign to Bastion | `string` | `""` | no |
| <a name="input_bastion_ssh_key_name"></a> [bastion\_ssh\_key\_name](#input\_bastion\_ssh\_key\_name) | Name of ssh key to use to access Bastion | `string` | `""` | no |
| <a name="input_bastion_tags"></a> [bastion\_tags](#input\_bastion\_tags) | Tags to be applied to all for Bastion | `map(string)` | `{}` | no |
| <a name="input_bastion_volume_size"></a> [bastion\_volume\_size](#input\_bastion\_volume\_size) | EBS volume size for Bastion root volume | `string` | `"20"` | no |
| <a name="input_bastion_volume_type"></a> [bastion\_volume\_type](#input\_bastion\_volume\_type) | EBS volume type for Bastion root volume | `string` | `"gp2"` | no |
| <a name="input_bastion_whitelisted_access_cidrs"></a> [bastion\_whitelisted\_access\_cidrs](#input\_bastion\_whitelisted\_access\_cidrs) | The IPs, in CIDR block form (x.x.x.x/32), to whitelist access to the Bastion | `list(string)` | `[]` | no |
| <a name="input_rds_access_security_group_id"></a> [rds\_access\_security\_group\_id](#input\_rds\_access\_security\_group\_id) | The ID of the security group required to access the Chirpstack RDS instance | `string` | `""` | no |
| <a name="input_redis_access_security_group_id"></a> [redis\_access\_security\_group\_id](#input\_redis\_access\_security\_group\_id) | The ID of the security group required to access the Chirpstack Redis | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | `""` | no |
| <a name="input_vpc_public_subnet_id"></a> [vpc\_public\_subnet\_id](#input\_vpc\_public\_subnet\_id) | Subnet ID of the public subnet to deploy Bastion into | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IP access of the Bastion |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
