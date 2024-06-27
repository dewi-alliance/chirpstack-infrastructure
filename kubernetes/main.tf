resource "time_sleep" "this" {
  depends_on = [
    helm_release.lbc
  ]

  create_duration = "300s" # Adjust the duration as needed (e.g., "5m" for 5 minutes)
}

# ***************************************
#  Argo CD
# ***************************************
resource "random_string" "this" {
  length  = 8
  special = false
}

resource "random_password" "this" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$%?"
}

resource "aws_secretsmanager_secret" "this" {
  name        = "argocd-admin-credentials-${random_string.this.result}"
  description = "Admin credentials for ArgoCD"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(
    {
      password = random_password.this.result
      username = "admin"
    }
  )
}

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

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = random_password.this.bcrypt_hash
  }

  values = [
    file("${path.module}/config/argo-values.yaml")
  ]

  depends_on = [
    time_sleep.this
  ]
}

# ***************************************
#  AWS Load Balancer Controller
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
#  External DNS
# ***************************************
data "aws_iam_role" "external_dns_role" {
  name = "external-dns-role"
}

resource "kubernetes_service_account" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn"     = data.aws_iam_role.external_dns_role.arn
      "meta.helm.sh/release-name"      = "external-dns",
      "meta.helm.sh/release-namespace" = "kube-system",
    }
    labels = {
      "app.kubernetes.io/managed-by" = "Helm",
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
    kubernetes_service_account.external_dns,
    time_sleep.this
  ]
}

# ***************************************
#  Cluster Autoscaler
# ***************************************
data "aws_iam_role" "cluster_autoscaler_role" {
  name = "cluster-autoscaler-role"
}

resource "helm_release" "cluster_autoscaler" {
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.36.0"

  name             = "cluster-autoscaler"
  namespace        = "kube-system"
  create_namespace = true
  cleanup_on_fail  = true

  set {
    name  = "autoDiscovery.clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = data.aws_iam_role.cluster_autoscaler_role.arn
  }

  values = [
    file("${path.module}/config/cluster-autoscaler-values.yaml")
  ]

  depends_on = [
    time_sleep.this
  ]
}

# ***************************************
#  Metrics Server
# ***************************************
resource "helm_release" "metrics_server" {
  name = "metrics-server"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "7.2.6"

  set {
    name  = "replicas"
    value = 2
  }

  values = [
    file("${path.module}/config/metrics-server-values.yaml")
  ]

  depends_on = [
    time_sleep.this
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
