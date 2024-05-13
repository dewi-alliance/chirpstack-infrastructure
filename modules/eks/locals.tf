locals {
  iam_role_policy_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"

  pre_compute_cluster_addons = {
    vpc-cni = {
      addon_version     = var.vpc_cni_addon
      resolve_conflicts = "OVERWRITE"
      configuration_values = jsonencode({
        init = {
          env = {
            DISABLE_TCP_EARLY_DEMUX = "true"
          }
        }
        env = {
          ENABLE_POD_ENI = "true"
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  post_compute_cluster_addons = {
    coredns = {
      addon_version     = var.coredns_version
      resolve_conflicts = "OVERWRITE"
    }
    # aws eks describe-addon-versions --addon-name kube-proxy
    kube-proxy = {
      addon_version     = var.kube_proxy_version
      resolve_conflicts = "OVERWRITE"
    }
  }
}
