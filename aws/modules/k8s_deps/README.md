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
| [aws_iam_policy.cluster_autoscaler_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_dns_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_secrets_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.grafana_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lbc_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.cluster_autoscaler_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role) | resource |
| [aws_iam_role.external_dns_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role) | resource |
| [aws_iam_role.external_secrets_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role) | resource |
| [aws_iam_role.grafana_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role) | resource |
| [aws_iam_role.lbc_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster_autoscaler_policy_attachement](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.external_dns_policy_attatchment](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.external_secrets_policy_attachement](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.grafana_policy_attachement](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lbc_policy_attatchment](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group) | resource |
| [aws_security_group.nlb_mqtt](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nlb_mqtt](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cluster_autoscaler_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cluster_autoscaler_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_dns_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_dns_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_secrets_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_secrets_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.grafana_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.grafana_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lbc_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lbc_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for infrastructure. | `string` | `""` | no |
| <a name="input_oidc_provider"></a> [oidc\_provider](#input\_oidc\_provider) | The OpenID Connect identity provider (issuer URL without leading `https://`) | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | `""` | no |
| <a name="input_whitelisted_cidrs"></a> [whitelisted\_cidrs](#input\_whitelisted\_cidrs) | The IPv4 CIDR blocks for whitelisted IPs accessing Chirpstack, Argo, Grafana, and MQTT | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_security_group_id"></a> [alb\_security\_group\_id](#output\_alb\_security\_group\_id) | Security Group ID for Application Load Balancer Security Group |
| <a name="output_nlb_mqtt_security_group_id"></a> [nlb\_mqtt\_security\_group\_id](#output\_nlb\_mqtt\_security\_group\_id) | Security Group ID for Network Load Balancer Security Group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
