# chirpstack-aws-infrastructure
Terraform repository defining AWS infrastructure for a production ChirpStack configuration

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.50.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ./modules/bastion | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ./modules/eks | n/a |
| <a name="module_elasticache"></a> [elasticache](#module\_elasticache) | ./modules/elasticache | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | ./modules/rds | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_availability_zones"></a> [aws\_availability\_zones](#input\_aws\_availability\_zones) | A list AWS availability zones for the VPC. | `list(string)` | `[]` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for infrastructure. | `string` | `""` | no |
| <a name="input_bastion_instance_type"></a> [bastion\_instance\_type](#input\_bastion\_instance\_type) | EC2 instance type for Bastion | `string` | `"t3.micro"` | no |
| <a name="input_bastion_private_ip"></a> [bastion\_private\_ip](#input\_bastion\_private\_ip) | Private IP address to assign to Bastion | `string` | `""` | no |
| <a name="input_bastion_ssh_key_name"></a> [bastion\_ssh\_key\_name](#input\_bastion\_ssh\_key\_name) | Name of ssh key to use to access Bastion | `string` | `""` | no |
| <a name="input_bastion_tags"></a> [bastion\_tags](#input\_bastion\_tags) | Tags to be applied to all for Bastion | `map(string)` | `{}` | no |
| <a name="input_bastion_volume_size"></a> [bastion\_volume\_size](#input\_bastion\_volume\_size) | EBS volume size for Bastion root volume | `string` | `"20"` | no |
| <a name="input_bastion_volume_type"></a> [bastion\_volume\_type](#input\_bastion\_volume\_type) | EBS volume type for Bastion root volume | `string` | `"gp2"` | no |
| <a name="input_bastion_whitelisted_access_ips"></a> [bastion\_whitelisted\_access\_ips](#input\_bastion\_whitelisted\_access\_ips) | The IPs, in CIDR block form (x.x.x.x/32), to whitelist access to the Bastion | `list(string)` | `[]` | no |
| <a name="input_cloudwatch_alarm_action_arns"></a> [cloudwatch\_alarm\_action\_arns](#input\_cloudwatch\_alarm\_action\_arns) | CloudWatch Alarm Action ARNs to report CloudWatch Alarms | `list(string)` | `[]` | no |
| <a name="input_cloudwatch_retention_in_days"></a> [cloudwatch\_retention\_in\_days](#input\_cloudwatch\_retention\_in\_days) | Duration to retain EKS control plane logs | `number` | `90` | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | A list of IPv4 CIDR blocks for database subnets inside the VPC. | `list(string)` | `[]` | no |
| <a name="input_eks_addon_preserve"></a> [eks\_addon\_preserve](#input\_eks\_addon\_preserve) | Preserve the created add-on resources in the cluster when deleting the EKS add-on? | `bool` | `false` | no |
| <a name="input_eks_addon_resolve_conflicts_on_update"></a> [eks\_addon\_resolve\_conflicts\_on\_update](#input\_eks\_addon\_resolve\_conflicts\_on\_update) | How to resolve field value conflicts for an Amazon EKS add-on if you've changed a value from the Amazon EKS default value. Valid values are NONE, OVERWRITE, and PRESERVE. For more information, see the UpdateAddon API Docs (https://docs.aws.amazon.com/eks/latest/APIReference/API_UpdateAddon.html) | `string` | `"OVERWRITE"` | no |
| <a name="input_eks_authentication_mode"></a> [eks\_authentication\_mode](#input\_eks\_authentication\_mode) | The authentication mode for the cluster. Valid values are `CONFIG_MAP`, `API` or `API_AND_CONFIG_MAP` | `string` | `"API_AND_CONFIG_MAP"` | no |
| <a name="input_eks_bootstrap_cluster_creator_admin_permissions"></a> [eks\_bootstrap\_cluster\_creator\_admin\_permissions](#input\_eks\_bootstrap\_cluster\_creator\_admin\_permissions) | Bootstrap the access config values to the cluster? For more information, see Amazon EKS Access Entries (https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html) | `bool` | `true` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS Cluster | `string` | `""` | no |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Version of the EKS Cluster | `string` | `""` | no |
| <a name="input_eks_coredns_version"></a> [eks\_coredns\_version](#input\_eks\_coredns\_version) | Version of the Coredns cluster addon | `string` | `"v1.26.9-eksbuild.2"` | no |
| <a name="input_eks_endpoint_private_access"></a> [eks\_endpoint\_private\_access](#input\_eks\_endpoint\_private\_access) | Enable the Amazon EKS private API server endpoint? | `bool` | `false` | no |
| <a name="input_eks_endpoint_public_access"></a> [eks\_endpoint\_public\_access](#input\_eks\_endpoint\_public\_access) | Enable the Amazon EKS public API server endpoint? | `bool` | `true` | no |
| <a name="input_eks_kube_proxy_version"></a> [eks\_kube\_proxy\_version](#input\_eks\_kube\_proxy\_version) | Version of the Kube-Proxy cluster addon | `string` | `"v1.15.1-eksbuild.1"` | no |
| <a name="input_eks_log_types"></a> [eks\_log\_types](#input\_eks\_log\_types) | A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html) | `list(string)` | <pre>[<br>  "audit",<br>  "api",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_eks_tags"></a> [eks\_tags](#input\_eks\_tags) | Additional tags for all resources related to EKS | `map(string)` | `{}` | no |
| <a name="input_eks_vpc_cni_version"></a> [eks\_vpc\_cni\_version](#input\_eks\_vpc\_cni\_version) | Version of the VPC CNI cluster addon | `string` | `"v1.9.3-eksbuild.7"` | no |
| <a name="input_kms_enable_key_rotation"></a> [kms\_enable\_key\_rotation](#input\_kms\_enable\_key\_rotation) | Enable KMS key rotation?. For more information, see Rotating KMS Keys (https://docs.aws.amazon.com/kms/latest/developerguide/rotate-keys.html) | `bool` | `true` | no |
| <a name="input_kms_key_usage"></a> [kms\_key\_usage](#input\_kms\_key\_usage) | Specifies the intended use of the key. Valid values: ENCRYPT\_DECRYPT, SIGN\_VERIFY, or GENERATE\_VERIFY\_MAC | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_node_group_ami_type"></a> [node\_group\_ami\_type](#input\_node\_group\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. See the [AWS documentation](https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType) for valid values | `string` | `"AL2_x86_64"` | no |
| <a name="input_node_group_capacity_type"></a> [node\_group\_capacity\_type](#input\_node\_group\_capacity\_type) | Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT` | `string` | `"ON_DEMAND"` | no |
| <a name="input_node_group_desired_size"></a> [node\_group\_desired\_size](#input\_node\_group\_desired\_size) | Desired number of nodes in EKS cluster | `number` | `1` | no |
| <a name="input_node_group_disk_size"></a> [node\_group\_disk\_size](#input\_node\_group\_disk\_size) | Disk size in GiB for nodes. Defaults to `20`. | `number` | `null` | no |
| <a name="input_node_group_instance_types"></a> [node\_group\_instance\_types](#input\_node\_group\_instance\_types) | Set of instance types associated with the EKS Node Group. Defaults to `["m5.large"]` | `list(string)` | <pre>[<br>  "m5.large"<br>]</pre> | no |
| <a name="input_node_group_max_size"></a> [node\_group\_max\_size](#input\_node\_group\_max\_size) | Maximum number of nodes in EKS cluster | `number` | `1` | no |
| <a name="input_node_group_max_unavailable_percentage"></a> [node\_group\_max\_unavailable\_percentage](#input\_node\_group\_max\_unavailable\_percentage) | Desired max percentage of unavailable worker nodes during node group update. | `number` | `33` | no |
| <a name="input_node_group_min_size"></a> [node\_group\_min\_size](#input\_node\_group\_min\_size) | Minimum number of nodes in EKS cluster | `number` | `1` | no |
| <a name="input_parameter_group_family"></a> [parameter\_group\_family](#input\_parameter\_group\_family) | The family of the ElastiCache parameter group | `string` | `""` | no |
| <a name="input_parameter_group_parameters"></a> [parameter\_group\_parameters](#input\_parameter\_group\_parameters) | List of ElastiCache parameters to apply | `list(map(string))` | `[]` | no |
| <a name="input_pg_engine_version"></a> [pg\_engine\_version](#input\_pg\_engine\_version) | Postgres database engine version. Defaults to 14.10, used by Chirpstack. | `string` | `"14.10"` | no |
| <a name="input_pg_family"></a> [pg\_family](#input\_pg\_family) | Postgres family for parameter group for mandating SSL. Defaults to postgres14 used by Chirpstack. | `string` | `"postgres14"` | no |
| <a name="input_pg_log_exports"></a> [pg\_log\_exports](#input\_pg\_log\_exports) | Enable CloudWatch log exports | `list(string)` | <pre>[<br>  "postgresql"<br>]</pre> | no |
| <a name="input_pg_name"></a> [pg\_name](#input\_pg\_name) | Postgres database name | `string` | `""` | no |
| <a name="input_pg_ssl_required"></a> [pg\_ssl\_required](#input\_pg\_ssl\_required) | Require SSL to connect to database? | `bool` | `true` | no |
| <a name="input_pg_username"></a> [pg\_username](#input\_pg\_username) | Postgres admin username | `string` | `"chirpstack_admin"` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Tags for private subnets. | `map(string)` | `{}` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of IPv4 CIDR blocks for private subnets inside the VPC. | `list(string)` | `[]` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Tags for public subnets. | `map(string)` | `{}` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | A list of IPv4 CIDR blocks for public subnets inside the VPC. | `list(string)` | `[]` | no |
| <a name="input_rds_backup_retention_period"></a> [rds\_backup\_retention\_period](#input\_rds\_backup\_retention\_period) | The days to retain backups for. Must be between 0 and 35. Default is 0. Must be greater than 0 if the database is used as a source for a Read Replica. Default is 30. | `number` | `30` | no |
| <a name="input_rds_db_port"></a> [rds\_db\_port](#input\_rds\_db\_port) | Database port | `number` | `5432` | no |
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
| <a name="input_redis_apply_immediately"></a> [redis\_apply\_immediately](#input\_redis\_apply\_immediately) | Apply database modifications immediately (or during the next maintenance window)? Default is `false` | `bool` | `false` | no |
| <a name="input_redis_at_rest_encryption_enabled"></a> [redis\_at\_rest\_encryption\_enabled](#input\_redis\_at\_rest\_encryption\_enabled) | Enable encryption at rest? | `bool` | `true` | no |
| <a name="input_redis_auth_token"></a> [redis\_auth\_token](#input\_redis\_auth\_token) | The password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true` | `string` | `null` | no |
| <a name="input_redis_auth_token_update_strategy"></a> [redis\_auth\_token\_update\_strategy](#input\_redis\_auth\_token\_update\_strategy) | Strategy to use when updating the `auth_token`. Valid values are `SET`, `ROTATE`, and `DELETE`. Defaults to `ROTATE` | `string` | `null` | no |
| <a name="input_redis_auto_minor_version_upgrade"></a> [redis\_auto\_minor\_version\_upgrade](#input\_redis\_auto\_minor\_version\_upgrade) | Apply minor version engine upgrades automatically to the underlying Cache Cluster instances during the maintenance window? Only supported for engine type `redis` and if the engine version is 6 or higher. Defaults to `true` | `bool` | `true` | no |
| <a name="input_redis_cluster_id"></a> [redis\_cluster\_id](#input\_redis\_cluster\_id) | Cluster name. ElastiCache converts this name to lowercase. Changing this value will re-create the resource | `string` | `""` | no |
| <a name="input_redis_engine_version"></a> [redis\_engine\_version](#input\_redis\_engine\_version) | Version number of the Redis cache engine to be used. If not set, defaults to the latest version | `string` | `null` | no |
| <a name="input_redis_ip_discovery"></a> [redis\_ip\_discovery](#input\_redis\_ip\_discovery) | The IP version to advertise in the discovery protocol. Valid values are `ipv4` or `ipv6`. Default is `ipv4` | `string` | `"ipv4"` | no |
| <a name="input_redis_kms_key_arn"></a> [redis\_kms\_key\_arn](#input\_redis\_kms\_key\_arn) | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if `at_rest_encryption_enabled = true` | `string` | `null` | no |
| <a name="input_redis_log_delivery_configuration"></a> [redis\_log\_delivery\_configuration](#input\_redis\_log\_delivery\_configuration) | Specifies the destination and format of Redis SLOWLOG or Redis Engine Log | `any` | <pre>{<br>  "engine-log": {<br>    "destination_type": "cloudwatch-logs",<br>    "log_format": "json"<br>  },<br>  "slow-log": {<br>    "destination_type": "cloudwatch-logs",<br>    "log_format": "json"<br>  }<br>}</pre> | no |
| <a name="input_redis_maintenance_window"></a> [redis\_maintenance\_window](#input\_redis\_maintenance\_window) | Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is `ddd:hh24:mi-ddd:hh24:mi` (24H Clock UTC) | `string` | `null` | no |
| <a name="input_redis_multi_az_enabled"></a> [redis\_multi\_az\_enabled](#input\_redis\_multi\_az\_enabled) | In multi-node clusters, enable Multi-AZ Support for the replication group? If true, `automatic_failover_enabled` must also be enabled. Defaults to `false` | `bool` | `false` | no |
| <a name="input_redis_network_type"></a> [redis\_network\_type](#input\_redis\_network\_type) | The IP versions for cache cluster connections. Valid values are `ipv4`, `ipv6` or `dual_stack`. Default is `ipv4`. | `string` | `"ipv4"` | no |
| <a name="input_redis_node_type"></a> [redis\_node\_type](#input\_redis\_node\_type) | The instance class used. For Memcached, changing this value will re-create the resource | `string` | `null` | no |
| <a name="input_redis_notification_topic_arn"></a> [redis\_notification\_topic\_arn](#input\_redis\_notification\_topic\_arn) | ARN of an SNS topic to send ElastiCache notifications | `string` | `null` | no |
| <a name="input_redis_preferred_cache_cluster_azs"></a> [redis\_preferred\_cache\_cluster\_azs](#input\_redis\_preferred\_cache\_cluster\_azs) | In multi-node clusters, list of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is considered. The first item in the list will be the primary node. Ignored when updating | `list(string)` | `[]` | no |
| <a name="input_redis_replicas_per_node_group"></a> [redis\_replicas\_per\_node\_group](#input\_redis\_replicas\_per\_node\_group) | In multi-node clusters, number of replica nodes in each node group. Changing this number will trigger a resizing operation before other settings modifications. Valid values are 0 to 5 | `number` | `null` | no |
| <a name="input_redis_single_node_cluster"></a> [redis\_single\_node\_cluster](#input\_redis\_single\_node\_cluster) | Deploy a single cluster with a single node (otherwise a multi-cluster with multiple nodes is created)? Default is `true` | `bool` | `true` | no |
| <a name="input_redis_snapshot_arns"></a> [redis\_snapshot\_arns](#input\_redis\_snapshot\_arns) | To restore from snapshot - single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3 | `list(string)` | `[]` | no |
| <a name="input_redis_snapshot_name"></a> [redis\_snapshot\_name](#input\_redis\_snapshot\_name) | To restore from snapshot - name of a snapshot from which to restore data into the new node group. Changing `snapshot_name` forces a new resource | `string` | `null` | no |
| <a name="input_redis_snapshot_retention_limit"></a> [redis\_snapshot\_retention\_limit](#input\_redis\_snapshot\_retention\_limit) | Number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. Default is `5`. | `number` | `5` | no |
| <a name="input_redis_snapshot_window"></a> [redis\_snapshot\_window](#input\_redis\_snapshot\_window) | Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. Example: `05:00-09:00` | `string` | `null` | no |
| <a name="input_redis_tags"></a> [redis\_tags](#input\_redis\_tags) | A map of tags to add to all Redis resources | `map(string)` | `{}` | no |
| <a name="input_redis_transit_encryption_enabled"></a> [redis\_transit\_encryption\_enabled](#input\_redis\_transit\_encryption\_enabled) | Enable encryption in-transit? Default is `true`. | `bool` | `true` | no |
| <a name="input_redis_transit_encryption_mode"></a> [redis\_transit\_encryption\_mode](#input\_redis\_transit\_encryption\_mode) | A setting that enables clients to migrate to in-transit encryption with no downtime. Valid values are preferred and required | `string` | `null` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Use single NAT gateway for cost savings (otherwise NAT gateways will be created per AZ)? Defaults to false. | `bool` | `false` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The IPv4 CIDR block for the VPC. | `string` | `""` | no |
| <a name="input_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#input\_vpc\_enable\_dns\_hostnames) | Enable DNS hostnames in the VPC. Defaults true. | `bool` | `true` | no |
| <a name="input_vpc_enable_dns_support"></a> [vpc\_enable\_dns\_support](#input\_vpc\_enable\_dns\_support) | Enable DNS support in the VPC? Defaults to true. | `bool` | `true` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC. Defaults to chirpstack-vpc. | `string` | `"chirpstack-vpc"` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Tags to be applied to all resources in the VPC. | `map(string)` | `{}` | no |
| <a name="input_with_bastion"></a> [with\_bastion](#input\_with\_bastion) | Should Bastion be created? | `bool` | `false` | no |
| <a name="input_with_rds_cloudwatch_alarms"></a> [with\_rds\_cloudwatch\_alarms](#input\_with\_rds\_cloudwatch\_alarms) | Deploy Cloudwatch Alarms for RDS? | `bool` | `false` | no |
| <a name="input_with_rds_read_replica"></a> [with\_rds\_read\_replica](#input\_with\_rds\_read\_replica) | Create read replica of primary DB? | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
