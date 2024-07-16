<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.50.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.50.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.rds](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.rds_read_replica](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_db_instance.rds](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/db_instance) | resource |
| [aws_db_instance.rds_read_replica](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/db_parameter_group) | resource |
| [aws_secretsmanager_secret.pg_chirpstack_credentials](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.pg_credentials](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.pg_helium_credentials](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.rotation](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.pg_chirpstack_vals](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.pg_credentials_vals](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.pg_helium_vals](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.rds_access_security_group](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group) | resource |
| [aws_security_group.rds_security_group](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group) | resource |
| [aws_security_group.secrets_manager_rotator_lambda_security_group](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group) | resource |
| [aws_security_group.secrets_manager_vpc_endpoint_security_group](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.rds_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group_rule) | resource |
| [aws_serverlessapplicationrepository_cloudformation_stack.rotator_cf_stack](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/serverlessapplicationrepository_cloudformation_stack) | resource |
| [aws_vpc_endpoint.secretsmanager](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/vpc_endpoint) | resource |
| [random_password.pg_admin_password](https://registry.terraform.io/providers/hashicorp/random/3.6.1/docs/resources/password) | resource |
| [random_password.pg_chirpstack_password](https://registry.terraform.io/providers/hashicorp/random/3.6.1/docs/resources/password) | resource |
| [random_password.pg_helium_password](https://registry.terraform.io/providers/hashicorp/random/3.6.1/docs/resources/password) | resource |
| [random_string.rds](https://registry.terraform.io/providers/hashicorp/random/3.6.1/docs/resources/string) | resource |
| [random_string.secretsmanager](https://registry.terraform.io/providers/hashicorp/random/3.6.1/docs/resources/string) | resource |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/partition) | data source |
| [aws_serverlessapplicationrepository_application.rotator](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/serverlessapplicationrepository_application) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region you're deploying to e.g., us-east-1 | `string` | `""` | no |
| <a name="input_cloudwatch_alarm_action_arns"></a> [cloudwatch\_alarm\_action\_arns](#input\_cloudwatch\_alarm\_action\_arns) | CloudWatch Alarm Action ARNs to report CloudWatch Alarms | `list(string)` | `[]` | no |
| <a name="input_database_subnet_ids"></a> [database\_subnet\_ids](#input\_database\_subnet\_ids) | List of database subnet IDs | `list(string)` | `[]` | no |
| <a name="input_pg_engine_version"></a> [pg\_engine\_version](#input\_pg\_engine\_version) | Postgres database engine version. Defaults to 14.10, used by Chirpstack. | `string` | `"14.10"` | no |
| <a name="input_pg_family"></a> [pg\_family](#input\_pg\_family) | Postgres family for parameter group for mandating SSL. Defaults to postgres14 used by Chirpstack. | `string` | `"postgres14"` | no |
| <a name="input_pg_log_exports"></a> [pg\_log\_exports](#input\_pg\_log\_exports) | Enable CloudWatch log exports | `list(string)` | <pre>[<br>  "postgresql"<br>]</pre> | no |
| <a name="input_pg_name"></a> [pg\_name](#input\_pg\_name) | Postgres database name | `string` | `""` | no |
| <a name="input_pg_ssl_required"></a> [pg\_ssl\_required](#input\_pg\_ssl\_required) | Require SSL to connect to database? | `bool` | `true` | no |
| <a name="input_pg_username"></a> [pg\_username](#input\_pg\_username) | Postgres admin username | `string` | `"chirpstack_admin"` | no |
| <a name="input_rds_backup_retention_period"></a> [rds\_backup\_retention\_period](#input\_rds\_backup\_retention\_period) | The days to retain backups for. Must be between 0 and 35. Default is 0. Must be greater than 0 if the database is used as a source for a Read Replica. Default is 30. | `number` | `30` | no |
| <a name="input_rds_db_port"></a> [rds\_db\_port](#input\_rds\_db\_port) | Database port | `number` | `5432` | no |
| <a name="input_rds_db_subnet_group_name"></a> [rds\_db\_subnet\_group\_name](#input\_rds\_db\_subnet\_group\_name) | Name of database subnet group | `string` | `""` | no |
| <a name="input_rds_deploy_from_snapshot"></a> [rds\_deploy\_from\_snapshot](#input\_rds\_deploy\_from\_snapshot) | Deploy RDS from snapshot? | `bool` | `false` | no |
| <a name="input_rds_iam_database_authentication_enabled"></a> [rds\_iam\_database\_authentication\_enabled](#input\_rds\_iam\_database\_authentication\_enabled) | Enable IAM database authentication? | `bool` | `true` | no |
| <a name="input_rds_instance_type"></a> [rds\_instance\_type](#input\_rds\_instance\_type) | Instance type for RDS | `string` | `"db.m6i.large"` | no |
| <a name="input_rds_max_storage_size"></a> [rds\_max\_storage\_size](#input\_rds\_max\_storage\_size) | Maximum EBS storage size for RDS | `number` | `1000` | no |
| <a name="input_rds_multi_az"></a> [rds\_multi\_az](#input\_rds\_multi\_az) | Multi-az deployment? | `bool` | `false` | no |
| <a name="input_rds_name"></a> [rds\_name](#input\_rds\_name) | The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier. | `string` | `""` | no |
| <a name="input_rds_skip_final_snapshot"></a> [rds\_skip\_final\_snapshot](#input\_rds\_skip\_final\_snapshot) | Create a final DB snapshot before the DB instance is deleted? If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from rds\_name. Default is false. | `bool` | `false` | no |
| <a name="input_rds_snapshot_identifier"></a> [rds\_snapshot\_identifier](#input\_rds\_snapshot\_identifier) | Snapshot identifier for restoration from snapshot. Requires rds\_deploy\_from\_snapshot to be true. | `string` | `""` | no |
| <a name="input_rds_storage_encrypted"></a> [rds\_storage\_encrypted](#input\_rds\_storage\_encrypted) | Encrypt the DB instance? | `bool` | `true` | no |
| <a name="input_rds_storage_size"></a> [rds\_storage\_size](#input\_rds\_storage\_size) | EBS storage size for RDS | `number` | `100` | no |
| <a name="input_rds_storage_type"></a> [rds\_storage\_type](#input\_rds\_storage\_type) | EBS storage type for RDS e.g., gp3 | `string` | `"gp3"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of VPC for RDS security group | `string` | `""` | no |
| <a name="input_with_rds_cloudwatch_alarms"></a> [with\_rds\_cloudwatch\_alarms](#input\_with\_rds\_cloudwatch\_alarms) | Deploy Cloudwatch Alarms for RDS? | `bool` | `false` | no |
| <a name="input_with_rds_read_replica"></a> [with\_rds\_read\_replica](#input\_with\_rds\_read\_replica) | Create read replica of primary DB? | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_access_security_group_id"></a> [rds\_access\_security\_group\_id](#output\_rds\_access\_security\_group\_id) | The ID of the security group required to access the Chirpstack RDS instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
