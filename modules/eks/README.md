<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.46.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.29.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.46.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.29.0 |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.9 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_ec2_tag.cluster_primary_security_group](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/ec2_tag) | resource |
| [aws_eks_addon.post_compute_cluster_addons](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/eks_addon) | resource |
| [aws_eks_addon.pre_compute_cluster_addons](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.oidc_provider](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.node_group_role](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_group_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/kms_key) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/launch_template) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/security_group) | resource |
| [aws_security_group.node](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.node](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/resources/security_group_rule) | resource |
| [kubernetes_config_map_v1_data.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/2.29.0/docs/resources/config_map_v1_data) | resource |
| [time_sleep.this](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster_auth.eks](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.node_group_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_session_context.current](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/data-sources/iam_session_context) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/5.46.0/docs/data-sources/partition) | data source |
| [tls_certificate.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_retention_in_days"></a> [cloudwatch\_retention\_in\_days](#input\_cloudwatch\_retention\_in\_days) | Duration to retain EKS control plane logs | `number` | `90` | no |
| <a name="input_eks_addon_preserve"></a> [eks\_addon\_preserve](#input\_eks\_addon\_preserve) | Indicates if you want to preserve the created resources when deleting the EKS add-on | `bool` | `false` | no |
| <a name="input_eks_addon_resolve_conflicts_on_update"></a> [eks\_addon\_resolve\_conflicts\_on\_update](#input\_eks\_addon\_resolve\_conflicts\_on\_update) | How to resolve field value conflicts for an Amazon EKS add-on if you've changed a value from the Amazon EKS default value. Valid values are NONE, OVERWRITE, and PRESERVE. For more information, see the UpdateAddon API Docs (https://docs.aws.amazon.com/eks/latest/APIReference/API_UpdateAddon.html) | `string` | `"OVERWRITE"` | no |
| <a name="input_eks_authentication_mode"></a> [eks\_authentication\_mode](#input\_eks\_authentication\_mode) | The authentication mode for the cluster. Valid values are `CONFIG_MAP`, `API` or `API_AND_CONFIG_MAP` | `string` | `"API_AND_CONFIG_MAP"` | no |
| <a name="input_eks_aws_auth_accounts"></a> [eks\_aws\_auth\_accounts](#input\_eks\_aws\_auth\_accounts) | List of account maps to add to the aws-auth configmap | `list(any)` | `[]` | no |
| <a name="input_eks_aws_auth_roles"></a> [eks\_aws\_auth\_roles](#input\_eks\_aws\_auth\_roles) | List of role maps to add to the aws-auth configmap | `list(any)` | `[]` | no |
| <a name="input_eks_aws_auth_users"></a> [eks\_aws\_auth\_users](#input\_eks\_aws\_auth\_users) | List of user maps to add to the aws-auth configmap | `list(any)` | `[]` | no |
| <a name="input_eks_bootstrap_cluster_creator_admin_permissions"></a> [eks\_bootstrap\_cluster\_creator\_admin\_permissions](#input\_eks\_bootstrap\_cluster\_creator\_admin\_permissions) | Whether or not to bootstrap the access config values to the cluster. For more information, see Amazon EKS Access Entries (https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html) | `bool` | `true` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS Cluster | `string` | `""` | no |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Version of the EKS Cluster | `string` | `""` | no |
| <a name="input_eks_coredns_version"></a> [eks\_coredns\_version](#input\_eks\_coredns\_version) | Version of the Coredns cluster addon | `string` | `"v1.26.9-eksbuild.2"` | no |
| <a name="input_eks_endpoint_private_access"></a> [eks\_endpoint\_private\_access](#input\_eks\_endpoint\_private\_access) | Whether the Amazon EKS private API server endpoint is enabled | `bool` | `false` | no |
| <a name="input_eks_endpoint_public_access"></a> [eks\_endpoint\_public\_access](#input\_eks\_endpoint\_public\_access) | Whether the Amazon EKS public API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_eks_kube_proxy_version"></a> [eks\_kube\_proxy\_version](#input\_eks\_kube\_proxy\_version) | Version of the Kube-Proxy cluster addon | `string` | `"v1.15.1-eksbuild.1"` | no |
| <a name="input_eks_log_types"></a> [eks\_log\_types](#input\_eks\_log\_types) | A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html) | `list(string)` | <pre>[<br>  "audit",<br>  "api",<br>  "authenticator"<br>]</pre> | no |
| <a name="input_eks_tags"></a> [eks\_tags](#input\_eks\_tags) | Additional tags for all resources related to EKS | `map(string)` | `{}` | no |
| <a name="input_eks_vpc_cni_addon"></a> [eks\_vpc\_cni\_addon](#input\_eks\_vpc\_cni\_addon) | Version of the VPC CNI cluster addon | `string` | `"v1.9.3-eksbuild.7"` | no |
| <a name="input_kms_enable_key_rotation"></a> [kms\_enable\_key\_rotation](#input\_kms\_enable\_key\_rotation) | Specifies whether key rotation is enabled. For more information, see Rotating KMS Keys (https://docs.aws.amazon.com/kms/latest/developerguide/rotate-keys.html) | `bool` | `true` | no |
| <a name="input_kms_key_usage"></a> [kms\_key\_usage](#input\_kms\_key\_usage) | Specifies the intended use of the key. Valid values: ENCRYPT\_DECRYPT, SIGN\_VERIFY, or GENERATE\_VERIFY\_MAC | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_node_group_ami_type"></a> [node\_group\_ami\_type](#input\_node\_group\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. See the [AWS documentation](https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType) for valid values | `string` | `"AL2_x86_64"` | no |
| <a name="input_node_group_capacity_type"></a> [node\_group\_capacity\_type](#input\_node\_group\_capacity\_type) | Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT` | `string` | `"ON_DEMAND"` | no |
| <a name="input_node_group_desired_size"></a> [node\_group\_desired\_size](#input\_node\_group\_desired\_size) | Desired number of nodes in EKS cluster | `number` | `1` | no |
| <a name="input_node_group_disk_size"></a> [node\_group\_disk\_size](#input\_node\_group\_disk\_size) | Disk size in GiB for nodes. Defaults to `20`. | `number` | `null` | no |
| <a name="input_node_group_instance_types"></a> [node\_group\_instance\_types](#input\_node\_group\_instance\_types) | Set of instance types associated with the EKS Node Group. Defaults to `["m5.large"]` | `list(string)` | <pre>[<br>  "m5.large"<br>]</pre> | no |
| <a name="input_node_group_max_size"></a> [node\_group\_max\_size](#input\_node\_group\_max\_size) | Maximum number of nodes in EKS cluster | `number` | `1` | no |
| <a name="input_node_group_max_unavailable_percentage"></a> [node\_group\_max\_unavailable\_percentage](#input\_node\_group\_max\_unavailable\_percentage) | Desired max percentage of unavailable worker nodes during node group update. | `number` | `33` | no |
| <a name="input_node_group_min_size"></a> [node\_group\_min\_size](#input\_node\_group\_min\_size) | Minimum number of nodes in EKS cluster | `number` | `1` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | `""` | no |
| <a name="input_vpc_private_subnet_ids"></a> [vpc\_private\_subnet\_ids](#input\_vpc\_private\_subnet\_ids) | Subnet IDs of the private subnet to deploy EKS cluster into | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_eks_cluster_auth"></a> [aws\_eks\_cluster\_auth](#output\_aws\_eks\_cluster\_auth) | EKS cluster auth token for instantiating Kubernetes provider |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64 encoded certificate data required to communicate with the cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for your Kubernetes API server |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console |
| <a name="output_oidc_provider"></a> [oidc\_provider](#output\_oidc\_provider) | The OpenID Connect identity provider (issuer URL without leading `https://`) |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | The ARN of the OIDC Provider |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
