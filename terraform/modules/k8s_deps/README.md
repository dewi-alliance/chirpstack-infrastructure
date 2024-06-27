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
| [aws_iam_policy.lbc_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.cluster_autoscaler_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role) | resource |
| [aws_iam_role.external_dns_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role) | resource |
| [aws_iam_role.lbc_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster_autoscaler_policy_attachement](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.external_dns_policy_attatchment](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lbc_policy_attatchment](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cluster_autoscaler_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cluster_autoscaler_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_dns_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_dns_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lbc_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lbc_policy](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_oidc_provider"></a> [oidc\_provider](#input\_oidc\_provider) | The OpenID Connect identity provider (issuer URL without leading `https://`) | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
