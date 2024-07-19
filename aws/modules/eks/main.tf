# ***************************************
# Module Data
# ***************************************
data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

data "aws_eks_cluster_auth" "eks" {
  name       = aws_eks_cluster.this.name
  depends_on = [aws_eks_cluster.this]
}

# ***************************************
# EKS Cluster
# ***************************************
resource "aws_eks_cluster" "this" {
  name                      = var.eks_cluster_name
  version                   = var.eks_cluster_version
  enabled_cluster_log_types = var.eks_log_types

  role_arn = aws_iam_role.this.arn

  access_config {
    authentication_mode                         = var.eks_authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.eks_bootstrap_cluster_creator_admin_permissions
  }

  vpc_config {
    security_group_ids      = [aws_security_group.cluster.id]
    subnet_ids              = var.vpc_private_subnet_ids
    endpoint_private_access = var.eks_endpoint_private_access
    endpoint_public_access  = var.eks_endpoint_public_access
    public_access_cidrs     = var.eks_public_access_cidrs
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.this.arn
    }
    resources = ["secrets"]
  }

  tags = var.eks_tags

  depends_on = [
    aws_iam_role_policy_attachment.this,
    aws_security_group_rule.cluster,
    aws_security_group_rule.node,
    aws_cloudwatch_log_group.this,
  ]
}

# ***************************************
# EKS Cluster IAM Role
# ***************************************
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name_prefix = "${var.eks_cluster_name}-role-"
  description = "IAM Role used by EKS control plane in performing cluster operations"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  inline_policy {
    name = var.eks_cluster_name

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["logs:CreateLogGroup"]
          Effect   = "Deny"
          Resource = "*"
        },
      ]
    })
  }

  tags = var.eks_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset([
    "${local.iam_role_policy_prefix}/AmazonEKSClusterPolicy",
    "${local.iam_role_policy_prefix}/AmazonEKSVPCResourceController"
  ])

  policy_arn = each.key
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "cluster_encryption" {
  policy_arn = aws_iam_policy.cluster_encryption.arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_policy" "cluster_encryption" {
  name_prefix = "${var.eks_cluster_name}-ClusterEncryption-"
  description = "Cluster encryption policy to allow cluster role to utilize AWS KMS CMK"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ListGrants",
          "kms:DescribeKey",
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.this.arn
      },
    ]
  })

  tags = var.eks_tags
}

# ***************************************
# KMS Key for EKS Secret Encryption
# ***************************************
resource "aws_kms_key" "this" {
  description = "${var.eks_cluster_name} cluster encryption key"

  enable_key_rotation = var.kms_enable_key_rotation
  key_usage           = var.kms_key_usage

  policy = data.aws_iam_policy_document.this.json

  tags = var.eks_tags
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "Default"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid = "KeyAdministration"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:ReplicateKey",
      "kms:ImportKeyMaterial"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_session_context.current.issuer_arn]
    }
  }

  statement {
    sid = "KeyUsage"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this.arn]
    }
  }
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.eks_cluster_name}"
  target_key_id = aws_kms_key.this.key_id
}

# ***************************************
# CloudWatch Log Group for EKS Control Plane logging
# ***************************************
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = var.cloudwatch_retention_in_days

  tags = merge(
    {
      Name = "/aws/eks/${var.eks_cluster_name}/cluster"
    },
    var.eks_tags
  )
}


# ***************************************
# EKS Control Plane Security Group Tags
# ***************************************
resource "aws_ec2_tag" "cluster_primary_security_group" {
  for_each = tomap(var.eks_tags)

  resource_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  key         = each.key
  value       = each.value
}

# ***************************************
# Additional EKS Control Plane Security Group
# ***************************************
resource "aws_security_group" "cluster" {
  name_prefix = "eks-cluster-additional-sg-${var.eks_cluster_name}-"
  description = "EKS cluster additional security group"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "eks-cluster-additional-sg-${var.eks_cluster_name}"
    },
    var.eks_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "cluster" {
  security_group_id        = aws_security_group.cluster.id
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
  description              = "Node groups to cluster API"
  source_security_group_id = aws_security_group.node.id # From node_group.tf
}

# ***************************************
# IRSA
# ***************************************
data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer

  tags = merge(
    {
      Name = "${var.eks_cluster_name}-eks-irsa"
    },
    var.eks_tags
  )
}

# ***************************************
#  EKS Addons
# ***************************************
locals {
  pre_compute_cluster_addons = {
    vpc-cni = {
      addon_version     = var.eks_vpc_cni_version
      resolve_conflicts = var.eks_addon_resolve_conflicts_on_update
      preserve          = var.eks_addon_preserve

      # For allowing security groups to be applied to K8s pods - https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
      configuration_values = jsonencode({
        init = {
          env = {
            DISABLE_TCP_EARLY_DEMUX = "true"
          }
        }
        env = {
          ENABLE_POD_ENI           = "true"
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  post_compute_cluster_addons = {
    coredns = {
      addon_version     = var.eks_coredns_version
      resolve_conflicts = var.eks_addon_resolve_conflicts_on_update
      preserve          = var.eks_addon_preserve
    }
    kube-proxy = {
      addon_version     = var.eks_kube_proxy_version
      resolve_conflicts = "OVERWRITE"
      preserve          = var.eks_addon_preserve
    }
    aws-ebs-csi-driver = {
      addon_version     = var.eks_ebs_csi_version
      resolve_conflicts = "OVERWRITE"
      preserve          = var.eks_addon_preserve
    }
  }
}

resource "aws_eks_addon" "pre_compute_cluster_addons" {
  for_each = tomap(local.pre_compute_cluster_addons)

  cluster_name = aws_eks_cluster.this.name

  addon_name           = try(each.value.name, each.key)
  addon_version        = try(each.value.addon_version, null)
  configuration_values = try(each.value.configuration_values, null)

  preserve                    = try(each.value.preserve, true)
  resolve_conflicts_on_update = try(each.value.resolve_conflicts_on_update, "OVERWRITE")


  tags = var.eks_tags
}

resource "aws_eks_addon" "post_compute_cluster_addons" {
  for_each = tomap(local.post_compute_cluster_addons)

  cluster_name = aws_eks_cluster.this.name

  addon_name           = try(each.value.name, each.key)
  addon_version        = try(each.value.addon_version, null)
  configuration_values = try(each.value.configuration_values, null)

  preserve                    = try(each.value.preserve, true)
  resolve_conflicts_on_update = try(each.value.resolve_conflicts_on_update, "OVERWRITE")

  depends_on = [
    aws_eks_node_group.this,
  ]

  tags = var.eks_tags
}
