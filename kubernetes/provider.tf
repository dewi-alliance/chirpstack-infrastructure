data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.eks_cluster_name
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Terraform  = "true"
      Chirpstack = "true"
    }
  }
}

# Kubernetes provider
# https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster#optional-configure-terraform-kubernetes-provider
# To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/terraform/kubernetes/deploy-nginx-kubernetes
# The Kubernetes provider is included in this file so the EKS module can complete successfully. Otherwise, it throws an error when creating `kubernetes_config_map.aws_auth`.
# You should **not** schedule deployments and services in this workspace. This keeps workspaces modular (one for provision EKS, another for scheduling Kubernetes resources) as per best practices.
provider "kubernetes" {
  host                   = try(data.aws_eks_cluster.eks.endpoint, null)
  cluster_ca_certificate = try(base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data), null)
  token                  = try(data.aws_eks_cluster_auth.eks.token, null)
}

provider "helm" {
  kubernetes {
    host                   = try(data.aws_eks_cluster.eks.endpoint, null)
    cluster_ca_certificate = try(base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data), null)
    token                  = try(data.aws_eks_cluster_auth.eks.token, null)
  }
}
