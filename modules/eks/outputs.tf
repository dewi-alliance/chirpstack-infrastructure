output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = try(aws_eks_cluster.this.name, null)
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = try(replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", ""), null)
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = try(aws_iam_openid_connect_provider.oidc_provider.arn, null)
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = try(aws_eks_cluster.this.endpoint, null)
}

output "cluster_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = try(aws_eks_cluster.this.vpc_config[0].cluster_security_group_id, null)
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = try(aws_eks_cluster.this.certificate_authority[0].data, null)
}

output "aws_eks_cluster_auth" {
  description = "EKS cluster auth token for instantiating Kubernetes provider"
  value       = try(data.aws_eks_cluster_auth.eks.token, null)
}
