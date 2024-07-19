# Kubernetes Systems Applications

This directory contains a set of Terraform Helm Release resources for deploying Kubernetes systems applications into the EKS cluster. In particular, this directory uses Terraform to deploy Helm templates for:

- [Argo CD](https://artifacthub.io/packages/helm/argo/argo-cd)
- [Argo CD applications](https://artifacthub.io/packages/helm/argo/argocd-apps) for Chirpstack and Helium
- [AWS Load Balancer Controller](https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller)
- [External DNS](https://artifacthub.io/packages/helm/external-dns/external-dns)
- [Cluster Autoscaler](https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler)
- [Metrics Server](https://artifacthub.io/packages/helm/bitnami/metrics-server)
- [External Secrets](https://artifacthub.io/packages/helm/external-secrets-operator/external-secrets)
- [Prometheus](https://artifacthub.io/packages/helm/prometheus-community/prometheus)
- [Grafana](https://artifacthub.io/packages/helm/grafana/grafana)

## Systems Applications Overview

A high-level overview of the systems applications deployed from the `kubernetes` directory is provided below. Each of the systems applications is deployed from a Helm template where the static values are provided on an application-by-application basis from the `./kubernetes/config/*-values.yaml` files. Dynamic, cluster-specific values are provided in-line via Terraform variables.

### Summary

- **Argo CD**: GitOps tool for deploying Chirpstack and Helium helm charts, respectively defined in the `./chirpstack` and `./helium` directories, into the EKS cluster. Admin credentials for logging into the Argo dashboard are stored in Secrets Manager.
- **Argo CD Applications**: Configures Argo Applications and Projects for the chirpstack and helium Helm charts.
- **AWS Load Balancer Controller**: Creates one AWS application load balancer in front of the Chirpstack, Argo, and Grafana dashboards and two AWS network load balancers, one in front of MQTT and another in front of Chirpstack Gateway Bridge(s). SSL termination is configured at the application load balancer and network load balancer in front of MQTT. There is no SSL for the load balancer in front of Chirpstack Gateway Bridge(s) as the traffic is UDP.
- **External DNS**: Creates AWS Route53 DNS entries for the Chirpstack, Argo, and Grafana dashboards, MQTT server, and Chirpstack Gateway Bridge instance(s).
- **Cluster Autoscaler**: Configured to add nodes to the EKS cluster as load demands.
- **Metrics Server**: Provides metrics driving horizontal pod autoscaler (HPA) definitions on Kubernetes Deployments. However, no deployments are configured with HPAs at this time but that is something that can be done after forking if desired.
- **External Secrets**: Configured to use AWS Secrets Manager as an external secrets repository and inject secrets into Kubernetes Pods. Only has IAM permissions to access secrets prefixed with `chirpstack/`.
- **Prometheus**: Kubernetes cluster, pod, and application metrics.
- **Grafana**: Configured to work with Prometheus, as well as AWS CloudWatch (e.g., for RDS and ElastiCache). Admin credentials for logging into the Grafana dashboard are stored in Secrets Manager.

Additionally, the directory deploys Kubernetes `SecurityGroupPolicy` CRDs for for pod-level security groups for Chirpstack and Helium applications for RDS and ElastiCache access. It also configures the K8s aws-auth configmap to allow AWS role, user, or account-based kubectl access to the cluster. Chirpstack dashboard admin credentials and api secret are created and stored in Secrets Manager but require manual configuration.

## Usage

Similar to the discussion in the `aws` directory, in deploying the Kubernetes systems applications via Terraform, the description provided below assume that S3 is used as a [Terraform remote backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3). If other Terraform state management methods want to be used, the configuration in `verions.tf` will need to be updated and step 3 from the Prerequisites section can be omitted.

### Prerequisites

1. In Route53, create a Hosted Zone to use for DNS for cluster applications (e.g., example.com)
2. In AWS Certificate Manager, create a public wildcard certificate (e.g., *.example.com) for the domain specified in the Hosted Zone
3. Create `backend.tfvars` file with contents as shown below:

```txt
bucket         = "<s3_bucket_name>"
key            = "kubernetes/terraform.tfstate" # or whatever prefix/key structure you want, just can't conflict with that of the aws dir
region         = "<aws_region>"
dynamodb_table = "<dynamodb_bucket_name>"
```
4. Create `terraform.tfvars` file. An example file is shown below:

```txt
argo_url = "<insert_argo_subdomain>" # argo.example.com
repo_url = "<insert_forked_repo_url>"

aws_region       = "us-east-1"
eks_cluster_name = "chirpstack-cluster"
zone_id          = "<insert_hosted_zone_id>"

grafana_url  = "<insert_grafana_subdomain>" # grafana.example.com
with_grafana = true

deploy_externa_secrets_crd = false # Need to set to false on first deployment

argo_chart_version               = "7.1.3"
argo_apps_chart_version          = "2.0.0"
aws_lbc_chart_version            = "1.8.1"
external_dns_chart_version       = "1.14.5"
cluster_autoscaler_chart_version = "9.36.0"
metrics_server_chart_version     = "7.2.6"
prometheus_chart_version         = "25.22.0"
grafana_chart_version            = "8.1.1"
external_secrets_chart_version   = "0.9.20"
```

### Deployment

1. Provide AWS credentials.
2. `terraform init --backend-config=backend.tfvars`
3. Run first `terraform apply` with `deploy_externa_secrets_crd` set to `false`
4. Run second `terraform apply` with `deploy_externa_secrets_crd` set to `true`

### Post Deployment Notes

At this point, the Kubernetes systems applications will be deployed and, since Argo is configured to deploy the Chirptack and Helium Helm templates respectively defined in `./chirpstack` and `./helium`, the Chirptack and Helium applications will be deployed as well, albeit in a sad, broken state.

To address this, continue on to `./chirpstack`!

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.50.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.31.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.2 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.11.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.50.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.31.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.11.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.argo](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.chirpstack_api_secret](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.chirpstack_dashboard](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.mqtt_secret](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.argo](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.chirpstack_api_secret](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.chirpstack_dashboard](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.grafana](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.mqtt_secret](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/resources/secretsmanager_secret_version) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/2.14.0/docs/resources/release) | resource |
| [helm_release.argocd_apps](https://registry.terraform.io/providers/hashicorp/helm/2.14.0/docs/resources/release) | resource |
| [helm_release.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/helm/2.14.0/docs/resources/release) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/2.14.0/docs/resources/release) | resource |
| [helm_release.external_secrets](https://registry.terraform.io/providers/hashicorp/helm/2.14.0/docs/resources/release) | resource |
| [helm_release.grafana](https://registry.terraform.io/providers/hashicorp/helm/2.14.0/docs/resources/release) | resource |
| [helm_release.lbc](https://registry.terraform.io/providers/hashicorp/helm/2.14.0/docs/resources/release) | resource |
| [helm_release.metrics_server](https://registry.terraform.io/providers/hashicorp/helm/2.14.0/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/2.14.0/docs/resources/release) | resource |
| [kubernetes_config_map_v1_data.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/config_map_v1_data) | resource |
| [kubernetes_manifest.db_chirpstack_access_sg](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.db_helium_access_sg](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.external_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.secrets_manager_access_sg](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_service_account.external_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/service_account) | resource |
| [kubernetes_service_account.lbc](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/service_account) | resource |
| [random_password.argo](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/password) | resource |
| [random_password.chirpstack_api_secret](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/password) | resource |
| [random_password.chirpstack_dashboard](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/password) | resource |
| [random_password.grafana](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/password) | resource |
| [random_password.mqtt_password](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/password) | resource |
| [time_sleep.chirpstack](https://registry.terraform.io/providers/hashicorp/time/0.11.2/docs/resources/sleep) | resource |
| [time_sleep.external_secrets](https://registry.terraform.io/providers/hashicorp/time/0.11.2/docs/resources/sleep) | resource |
| [time_sleep.this](https://registry.terraform.io/providers/hashicorp/time/0.11.2/docs/resources/sleep) | resource |
| [aws_eks_cluster.chirpstack_cluster](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.eks](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_role.cluster_autoscaler_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_role) | data source |
| [aws_iam_role.external_dns_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_role) | data source |
| [aws_iam_role.external_secrets_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_role) | data source |
| [aws_iam_role.grafana_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_role) | data source |
| [aws_iam_role.lbc_role](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/iam_role) | data source |
| [aws_security_group.chirpstack_cluster_node](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/security_group) | data source |
| [aws_security_group.rds_access_security_group](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/security_group) | data source |
| [aws_security_group.redis_access_security_group](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/security_group) | data source |
| [aws_security_group.secrets_manager_access_security_group](https://registry.terraform.io/providers/hashicorp/aws/5.50.0/docs/data-sources/security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argo_apps_chart_version"></a> [argo\_apps\_chart\_version](#input\_argo\_apps\_chart\_version) | Version of Argo Apps Helm chart | `string` | `""` | no |
| <a name="input_argo_chart_version"></a> [argo\_chart\_version](#input\_argo\_chart\_version) | Version of Argo Helm chart | `string` | `""` | no |
| <a name="input_argo_url"></a> [argo\_url](#input\_argo\_url) | Argo URL | `string` | `""` | no |
| <a name="input_aws_lbc_chart_version"></a> [aws\_lbc\_chart\_version](#input\_aws\_lbc\_chart\_version) | Version of AWS Load Balancer Controller Helm chart | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for infrastructure. | `string` | `""` | no |
| <a name="input_cluster_autoscaler_chart_version"></a> [cluster\_autoscaler\_chart\_version](#input\_cluster\_autoscaler\_chart\_version) | Version of Cluster Autoscaler Helm chart | `string` | `""` | no |
| <a name="input_deploy_externa_secrets_crd"></a> [deploy\_externa\_secrets\_crd](#input\_deploy\_externa\_secrets\_crd) | Deploy External Secrets ClusterSecretStore? | `bool` | `false` | no |
| <a name="input_eks_aws_auth_accounts"></a> [eks\_aws\_auth\_accounts](#input\_eks\_aws\_auth\_accounts) | List of account maps to add to the aws-auth configmap | `list(any)` | `[]` | no |
| <a name="input_eks_aws_auth_roles"></a> [eks\_aws\_auth\_roles](#input\_eks\_aws\_auth\_roles) | List of role maps to add to the aws-auth configmap | `list(any)` | `[]` | no |
| <a name="input_eks_aws_auth_users"></a> [eks\_aws\_auth\_users](#input\_eks\_aws\_auth\_users) | List of user maps to add to the aws-auth configmap | `list(any)` | `[]` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS Cluster | `string` | `""` | no |
| <a name="input_external_dns_chart_version"></a> [external\_dns\_chart\_version](#input\_external\_dns\_chart\_version) | Version of External DNS Helm chart | `string` | `""` | no |
| <a name="input_external_secrets_chart_version"></a> [external\_secrets\_chart\_version](#input\_external\_secrets\_chart\_version) | Version of External Secretes Helm chart | `string` | `""` | no |
| <a name="input_grafana_chart_version"></a> [grafana\_chart\_version](#input\_grafana\_chart\_version) | Version of Grafana Helm chart | `string` | `""` | no |
| <a name="input_grafana_url"></a> [grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_metrics_server_chart_version"></a> [metrics\_server\_chart\_version](#input\_metrics\_server\_chart\_version) | Version of Metrics Server Helm chart | `string` | `""` | no |
| <a name="input_mqtt_user"></a> [mqtt\_user](#input\_mqtt\_user) | Name of the MQTT user | `string` | `"default"` | no |
| <a name="input_prometheus_chart_version"></a> [prometheus\_chart\_version](#input\_prometheus\_chart\_version) | Version of Prometheus Helm chart | `string` | `""` | no |
| <a name="input_repo_url"></a> [repo\_url](#input\_repo\_url) | Github repo URL | `string` | `""` | no |
| <a name="input_with_grafana"></a> [with\_grafana](#input\_with\_grafana) | Deploy Grafana? | `bool` | `false` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route53 Zone ID | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
