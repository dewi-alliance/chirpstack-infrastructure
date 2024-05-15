## Resources

| Name | Type |
|------|------|
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_db_subnet_group.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc_tags) | Tags to be applied to all resources in the VPC. | `map(string)` | `{}` | no |
| <a name="input_availability_zone_1"></a> [availability\_zone\_1](#input\_availability_zone_1) | First AWS availability zone. | `string` | `""` | yes |
| <a name="input_availability_zone_2"></a> [availability\_zone\_2](#input\_availability_zone_2) | Second AWS availability zone. | `string` | `""` | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc_name) | The name of the VPC. Defaults to chirpstack-vpc. | `string` | `"chirpstack-vpc"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc_cidr_block) | The IPv4 CIDR block for the VPC. | `string` | `""` | yes |
| <a name="input_vpc_enable_dns_support"></a> [vpc\_enable\_dns\_support](#input\_vpc_enable_dns_support) | A boolean flag to enable/disable DNS support in the VPC. Defaults to true. | `bool` | `true` | no |
| <a name="input_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#input\_vpc_enable_dns_hostnames) | A boolean flag to enable/disable DNS hostnames in the VPC. Defaults true. | `bool` | `true` | no |
| <a name="input_public_subnet_1"></a> [public\_subnet\_1](#input\_public_subnet_1) | The IPv4 CIDR block for the first public subnet. | `string` | `""` | yes |
| <a name="input_public_subnet_2"></a> [public\_subnet\_2](#input\_public_subnet_2) | The IPv4 CIDR block for the second public subnet. | `string` | `""` | yes |
| <a name="input_vpc_public_subnet_tags"></a> [vpc\_public\_subnet\_tags](#input\_vpc_public_subnet_tags) | Tags for public subnets. | `map(string)` | `{}` | no |
| <a name="input_private_subnet_1"></a> [private\_subnet\_1](#input\_private_subnet_1) | The IPv4 CIDR block for the first private subnet. | `string` | `""` | yes |
| <a name="input_private_subnet_2"></a> [private\_subnet\_2](#input\_private_subnet_2) | The IPv4 CIDR block for the second private subnet. | `string` | `""` | yes |
| <a name="input_vpc_private_subnet_tags"></a> [vpc\_private\_subnet\_tags](#input\_vpc_private_subnet_tags) | Tags for private subnets. | `map(string)` | `{}` | no |
| <a name="input_database_subnet_1"></a> [database\_subnet\_1](#input\_database_subnet_1) | The IPv4 CIDR block for the first database subnet. | `string` | `""` | yes |
| <a name="input_database_subnet_2"></a> [database\_subnet\_2](#input\_database_subnet_2) | The IPv4 CIDR block for the second database subnet. | `string` | `""` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc_id) | The ID of the VPC |
| <a name="output_public_subnets_ids"></a> [public\_subnets\_ids](#output\_public_subnets_ids) | List of IDs of public subnets |
| <a name="output_private_subnets_ids"></a> [private\_subnets\_ids](#output\_private_subnets_ids) | List of IDs of private subnets |
| <a name="output_database_subnet_ids"></a> [database\_subnet\_ids](#output\_database_subnet_ids) | List of IDs of database subnets |
| <a name="output_igw_id"></a> [igw\_id](#output\_igw_id) | The ID of the Internet Gateway |
| <a name="output_database_subnet_group_name"></a> [database\_subnet\_group\_name](#output\_database_subnet_group_name) | Name of database subnet group |
