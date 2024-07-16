resource "time_sleep" "this" {
  depends_on = [
    helm_release.lbc
  ]

  create_duration = "300s"
}

resource "time_sleep" "chirpstack" {

  depends_on = [
    helm_release.argocd_apps
  ]

  create_duration = "300s"
}

resource "random_string" "this" {
  length  = 8
  special = false
}

# ***************************************
#  Argo CD
# ***************************************
resource "random_password" "argo" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$%?"
}

resource "aws_secretsmanager_secret" "argo" {
  name        = "argocd-admin-credentials-${random_string.this.result}"
  description = "Credentials for ArgoCD admin user"
}

resource "aws_secretsmanager_secret_version" "argo" {
  secret_id = aws_secretsmanager_secret.argo.id
  secret_string = jsonencode(
    {
      password = random_password.argo.result
      username = "admin"
    }
  )
}

resource "helm_release" "argocd" {
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argo_chart_version

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
    value = random_password.argo.bcrypt_hash
  }

  values = [
    file("${path.module}/config/argo-values.yaml")
  ]

  depends_on = [
    time_sleep.this
  ]
}

# ***************************************
#  Argo CD - Applications
# ***************************************
resource "helm_release" "argocd_apps" {
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = var.argo_apps_chart_version

  name      = "argocd-apps"
  namespace = "argocd"

  set {
    name  = "applications.chirpstack.source.repoURL"
    value = var.repo_url
  }

  set {
    name  = "applications.helium.source.repoURL"
    value = var.repo_url
  }

  values = [
    file("${path.module}/config/argo-app-values.yaml")
  ]

  depends_on = [
    time_sleep.this,
    helm_release.argocd
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
  version    = var.aws_lbc_chart_version

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
  version    = var.external_dns_chart_version

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
  version    = var.cluster_autoscaler_chart_version

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
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  version    = var.metrics_server_chart_version

  name             = "metrics-server"
  namespace        = "kube-system"
  create_namespace = true
  cleanup_on_fail  = true

  values = [
    file("${path.module}/config/metrics-server-values.yaml")
  ]

  depends_on = [
    time_sleep.this
  ]
}

# ***************************************
#  Sealed Secrets
# ***************************************
resource "helm_release" "sealed_secrets" {
  repository = "https://bitnami-labs.github.io/sealed-secrets/"
  chart      = "sealed-secrets"
  version    = var.sealed_secrets_chart_version

  name             = "sealed-secrets-controller"
  namespace        = "kube-system"
  create_namespace = true
  cleanup_on_fail  = true
}

# ***************************************
#  Prometheus
# ***************************************
resource "helm_release" "prometheus" {
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = var.prometheus_chart_version

  name             = "prometheus"
  namespace        = "monitoring"
  create_namespace = true
  cleanup_on_fail  = true

  values = [
    file("${path.module}/config/prometheus-values.yaml")
  ]

  depends_on = [
    time_sleep.this
  ]
}

# ***************************************
#  Grafana
# ***************************************
data "aws_iam_role" "grafana_role" {
  name = "grafana-role"
}

resource "random_password" "grafana" {
  count = var.with_grafana ? 1 : 0

  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$%?"
}

resource "aws_secretsmanager_secret" "grafana" {
  count = var.with_grafana ? 1 : 0

  name        = "grafana-admin-credentials-${random_string.this.result}"
  description = "Credentials for Grafana admin user"
}

resource "aws_secretsmanager_secret_version" "grafana" {
  count = var.with_grafana ? 1 : 0

  secret_id = aws_secretsmanager_secret.grafana[0].id
  secret_string = jsonencode(
    {
      password = random_password.grafana[0].result
      username = "admin"
    }
  )
}

resource "helm_release" "grafana" {
  count = var.with_grafana ? 1 : 0

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = var.grafana_chart_version

  name             = "grafana"
  namespace        = "monitoring"
  create_namespace = true
  cleanup_on_fail  = true

  set {
    name  = "ingress.hosts[0]"
    value = var.grafana_url
  }

  set {
    name  = "service.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
    value = var.grafana_url
  }

  set {
    name  = "adminPassword"
    value = random_password.grafana[0].result
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = data.aws_iam_role.grafana_role.arn
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[1].jsonData.defaultRegion"
    value = var.aws_region
  }

  values = [
    file("${path.module}/config/grafana-values.yaml")
  ]

  depends_on = [
    time_sleep.this
  ]
}

# ***************************************
#  Security Group Policy
# ***************************************
data "aws_security_group" "rds_access_security_group" {
  name = "rds-access-security-group"
}

data "aws_security_group" "redis_access_security_group" {
  name = "redis-access-security-group"
}

data "aws_security_group" "chirpstack_cluster_node" {
  name = "chirpstack-cluster-node"
}

resource "kubernetes_manifest" "db_chirpstack_access_sg" {
  manifest = yamldecode(<<-EOF
    apiVersion: vpcresources.k8s.aws/v1beta1
    kind: SecurityGroupPolicy
    metadata:
      name: db-access-security-group-policy
      namespace: chirpstack
    spec:
      podSelector:
        matchLabels:
          security-group: db-access
      securityGroups:
        groupIds:
          - "${data.aws_security_group.rds_access_security_group.id}"
          - "${data.aws_security_group.redis_access_security_group.id}"
          - "${data.aws_security_group.chirpstack_cluster_node.id}"
    EOF
  )

  depends_on = [
    time_sleep.this,
    time_sleep.chirpstack,
  ]
}

resource "kubernetes_manifest" "db_helium_access_sg" {
  manifest = yamldecode(<<-EOF
    apiVersion: vpcresources.k8s.aws/v1beta1
    kind: SecurityGroupPolicy
    metadata:
      name: db-access-security-group-policy
      namespace: helium
    spec:
      podSelector:
        matchLabels:
          security-group: db-access
      securityGroups:
        groupIds:
          - "${data.aws_security_group.rds_access_security_group.id}"
          - "${data.aws_security_group.redis_access_security_group.id}"
          - "${data.aws_security_group.chirpstack_cluster_node.id}"
    EOF
  )

  depends_on = [
    time_sleep.this,
    time_sleep.chirpstack,
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

# ***************************************
#  Chirpstack dashboard
# ***************************************
resource "random_password" "chirpstack" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$%?"
}

resource "aws_secretsmanager_secret" "chirpstack" {
  name        = "chirpstack-admin-credentials-${random_string.this.result}"
  description = "Credentials for Chirpstack admin user"
}

resource "aws_secretsmanager_secret_version" "chirpstack" {
  secret_id = aws_secretsmanager_secret.chirpstack.id
  secret_string = jsonencode(
    {
      password = random_password.chirpstack.result
      username = "admin"
    }
  )
}
