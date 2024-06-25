# ***************************************
#  Argo CD Helm Chart
# ***************************************
resource "helm_release" "argocd" {
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.1.3"

  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "global.domain"
    value = var.argo_url
  }

  set {
    name  = "server.service.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
    value = var.argo_url
  }

  values = [
    file("${path.module}/config/argo-values.yaml")
  ]
}

# ***************************************
#  AWS Load Balancer Controller Helm Chart
# ***************************************
data "aws_iam_role" "lbc_role" {
  name = "aws-load-balancer-controller-role"
}

resource "kubernetes_service_account" "lbc" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn"     = data.aws_iam_role.lbc_role.arn,
      "meta.helm.sh/release-name"      = "aws-load-balancer-controller",
      "meta.helm.sh/release-namespace" = "kube-system",
    }
    labels = {
      "app.kubernetes.io/managed-by" = "Helm",
    }
  }
  automount_service_account_token = true
}

resource "helm_release" "lbc" {
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.8.1"

  name             = "aws-load-balancer-controller"
  namespace        = "kube-system"
  create_namespace = true
  cleanup_on_fail  = true

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  values = [
    file("${path.module}/config/aws-load-balancer-controller-values.yaml")
  ]

  depends_on = [
    kubernetes_service_account.lbc
  ]
}

# ***************************************
#  External DNS Helm Chart
# ***************************************
data "aws_iam_role" "external_dns_role" {
  name = "external-dns-role"
}

resource "kubernetes_service_account" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = data.aws_iam_role.external_dns_role.arn
    }
  }
  automount_service_account_token = true
}

resource "helm_release" "external_dns" {
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.14.5"

  name             = "external-dns"
  namespace        = "kube-system"
  create_namespace = true
  cleanup_on_fail  = true

  set {
    name  = "txtOwnerId"
    value = var.zone_id
  }

  set {
    name  = "env[0].value"
    value = var.aws_region
  }

  set {
    name  = "env[0].name"
    value = "AWS_DEFAULT_REGION"
  }

  values = [
    file("${path.module}/config/external-dns-values.yaml")
  ]

  depends_on = [
    kubernetes_service_account.external_dns
  ]
}

# ***************************************
#  K8s aws-auth configmap
# ***************************************
locals {
  manage_aws_auth_configmap = (
    length(var.eks_aws_auth_roles) > 0 ||
    length(var.eks_aws_auth_users) > 0 ||
    length(var.eks_aws_auth_accounts) > 0
  )
  aws_auth_configmap_data = {
    mapRoles    = yamlencode(var.eks_aws_auth_roles)
    mapUsers    = yamlencode(var.eks_aws_auth_users)
    mapAccounts = yamlencode(var.eks_aws_auth_accounts)
  }
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  count = local.manage_aws_auth_configmap ? 1 : 0

  force = true

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = local.aws_auth_configmap_data
}
