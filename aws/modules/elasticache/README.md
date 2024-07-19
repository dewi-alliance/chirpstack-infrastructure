<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.50.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.1 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.11.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.50.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.1 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.11.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/elasticache_subnet_group) | resource |
| [aws_elasticache_user.chirpstack](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/elasticache_user) | resource |
| [aws_elasticache_user.default](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/elasticache_user) | resource |
| [aws_elasticache_user.helium](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/elasticache_user) | resource |
| [aws_elasticache_user_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/elasticache_user_group) | resource |
| [aws_elasticache_user_group_association.chirpstack](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/elasticache_user_group_association) | resource |
| [aws_elasticache_user_group_association.helium](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/elasticache_user_group_association) | resource |
| [aws_secretsmanager_secret.redis_chirpstack_credentials](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_default_credentials](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_helium_credentials](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.redis_chirpstack_vals](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_default_vals](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_helium_vals](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.redis_access_security_group](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group) | resource |
| [aws_security_group.redis_security_group](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.redis_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group_rule) | resource |
| [random_password.redis_chirpstack_password](https://registry.terraform.io/providers/hashicorp/random/3.6.1/docs/resources/password) | resource |
| [random_password.redis_default_password](https://registry.terraform.io/providers/hashicorp/random/3.6.1/docs/resources/password) | resource |
| [random_password.redis_helium_password](https://registry.terraform.io/providers/hashicorp/random/3.6.1/docs/resources/password) | resource |
| [random_string.redis](https://registry.terraform.io/providers/hashicorp/random/3.6.1/docs/resources/string) | resource |
| [time_sleep.this](https://registry.terraform.io/providers/hashicorp/time/0.11.2/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region you're deploying to e.g., us-east-1 | `string` | `""` | no |
| <a name="input_database_subnet_ids"></a> [database\_subnet\_ids](#input\_database\_subnet\_ids) | Subnet IDs of the database subnet for creating Redis subnet group | `list(string)` | `[]` | no |
| <a name="input_parameter_group_family"></a> [parameter\_group\_family](#input\_parameter\_group\_family) | The family of the ElastiCache parameter group | `string` | `""` | no |
| <a name="input_parameter_group_parameters"></a> [parameter\_group\_parameters](#input\_parameter\_group\_parameters) | List of ElastiCache parameters to apply | `list(map(string))` | `[]` | no |
| <a name="input_redis_apply_immediately"></a> [redis\_apply\_immediately](#input\_redis\_apply\_immediately) | Apply database modifications immediately (or during the next maintenance window)? Default is `false` | `bool` | `false` | no |
| <a name="input_redis_at_rest_encryption_enabled"></a> [redis\_at\_rest\_encryption\_enabled](#input\_redis\_at\_rest\_encryption\_enabled) | Enable encryption at rest? | `bool` | `true` | no |
| <a name="input_redis_auth_token"></a> [redis\_auth\_token](#input\_redis\_auth\_token) | The password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true` | `string` | `null` | no |
| <a name="input_redis_auth_token_update_strategy"></a> [redis\_auth\_token\_update\_strategy](#input\_redis\_auth\_token\_update\_strategy) | Strategy to use when updating the `auth_token`. Valid values are `SET`, `ROTATE`, and `DELETE`. Defaults to `ROTATE` | `string` | `null` | no |
| <a name="input_redis_auto_minor_version_upgrade"></a> [redis\_auto\_minor\_version\_upgrade](#input\_redis\_auto\_minor\_version\_upgrade) | Apply minor version engine upgrades automatically to the underlying Cache Cluster instances during the maintenance window? Only supported for engine type `redis` and if the engine version is 6 or higher. Defaults to `true` | `bool` | `true` | no |
| <a name="input_redis_cluster_id"></a> [redis\_cluster\_id](#input\_redis\_cluster\_id) | Group identifier. ElastiCache converts this name to lowercase. Changing this value will re-create the resource | `string` | `""` | no |
| <a name="input_redis_engine_version"></a> [redis\_engine\_version](#input\_redis\_engine\_version) | Version number of the Redis cache engine to be used. If not set, defaults to the latest version | `string` | `null` | no |
| <a name="input_redis_ip_discovery"></a> [redis\_ip\_discovery](#input\_redis\_ip\_discovery) | The IP version to advertise in the discovery protocol. Valid values are `ipv4` or `ipv6` | `string` | `null` | no |
| <a name="input_redis_kms_key_arn"></a> [redis\_kms\_key\_arn](#input\_redis\_kms\_key\_arn) | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if `at_rest_encryption_enabled = true` | `string` | `null` | no |
| <a name="input_redis_log_delivery_configuration"></a> [redis\_log\_delivery\_configuration](#input\_redis\_log\_delivery\_configuration) | Specifies the destination and format of Redis SLOWLOG or Redis Engine Log | `any` | <pre>{<br>  "engine-log": {<br>    "destination_type": "cloudwatch-logs",<br>    "log_format": "json"<br>  },<br>  "slow-log": {<br>    "destination_type": "cloudwatch-logs",<br>    "log_format": "json"<br>  }<br>}</pre> | no |
| <a name="input_redis_maintenance_window"></a> [redis\_maintenance\_window](#input\_redis\_maintenance\_window) | Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is `ddd:hh24:mi-ddd:hh24:mi` (24H Clock UTC) | `string` | `null` | no |
| <a name="input_redis_multi_az_enabled"></a> [redis\_multi\_az\_enabled](#input\_redis\_multi\_az\_enabled) | In multi-node clusters, enable Multi-AZ Support for the replication group? If true, `automatic_failover_enabled` must also be enabled. Defaults to `false` | `bool` | `false` | no |
| <a name="input_redis_network_type"></a> [redis\_network\_type](#input\_redis\_network\_type) | The IP versions for cache cluster connections. Valid values are `ipv4`, `ipv6` or `dual_stack` | `string` | `null` | no |
| <a name="input_redis_node_type"></a> [redis\_node\_type](#input\_redis\_node\_type) | The instance class used. For Memcached, changing this value will re-create the resource | `string` | `null` | no |
| <a name="input_redis_notification_topic_arn"></a> [redis\_notification\_topic\_arn](#input\_redis\_notification\_topic\_arn) | ARN of an SNS topic to send ElastiCache notifications to | `string` | `null` | no |
| <a name="input_redis_preferred_cache_cluster_azs"></a> [redis\_preferred\_cache\_cluster\_azs](#input\_redis\_preferred\_cache\_cluster\_azs) | List of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is considered. The first item in the list will be the primary node. Ignored when updating | `list(string)` | `[]` | no |
| <a name="input_redis_replicas_per_node_group"></a> [redis\_replicas\_per\_node\_group](#input\_redis\_replicas\_per\_node\_group) | Number of replica nodes in each node group. Changing this number will trigger a resizing operation before other settings modifications. Valid values are 0 to 5 | `number` | `null` | no |
| <a name="input_redis_single_node_cluster"></a> [redis\_single\_node\_cluster](#input\_redis\_single\_node\_cluster) | Deploy a single cluster with a single node (otherwise a multi-cluster with multiple nodes is created)? Default is `true` | `bool` | `true` | no |
| <a name="input_redis_snapshot_arns"></a> [redis\_snapshot\_arns](#input\_redis\_snapshot\_arns) | Single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3 | `list(string)` | `[]` | no |
| <a name="input_redis_snapshot_name"></a> [redis\_snapshot\_name](#input\_redis\_snapshot\_name) | Name of a snapshot from which to restore data into the new node group. Changing `snapshot_name` forces a new resource | `string` | `null` | no |
| <a name="input_redis_snapshot_retention_limit"></a> [redis\_snapshot\_retention\_limit](#input\_redis\_snapshot\_retention\_limit) | Number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them | `number` | `null` | no |
| <a name="input_redis_snapshot_window"></a> [redis\_snapshot\_window](#input\_redis\_snapshot\_window) | Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. Example: `05:00-09:00` | `string` | `null` | no |
| <a name="input_redis_tags"></a> [redis\_tags](#input\_redis\_tags) | A map of tags to add to all Redis resources | `map(string)` | `{}` | no |
| <a name="input_redis_transit_encryption_enabled"></a> [redis\_transit\_encryption\_enabled](#input\_redis\_transit\_encryption\_enabled) | Enable encryption in-transit? Default is `true`. | `bool` | `true` | no |
| <a name="input_redis_transit_encryption_mode"></a> [redis\_transit\_encryption\_mode](#input\_redis\_transit\_encryption\_mode) | A setting that enables clients to migrate to in-transit encryption with no downtime. Valid values are preferred and required | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_redis_access_security_group_id"></a> [redis\_access\_security\_group\_id](#output\_redis\_access\_security\_group\_id) | The ID of the security group required to access Redis |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
