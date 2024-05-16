# ***************************************
# AWS General
# ***************************************
variable "aws_region" {
  description = "AWS region for infrastructure."
  type        = string
  default     = ""
}

variable "aws_availability_zones" {
  description = "A list AWS availability zones for the VPC."
  type        = list(string)
  default     = []
}

# ***************************************
# VPC
# ***************************************
variable "vpc_name" {
  description = "The name of the VPC. Defaults to chirpstack-vpc."
  type        = string
  default     = "chirpstack-vpc"
}

variable "vpc_cidr_block" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = ""
}

variable "vpc_enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults to true."
  type        = bool
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults true."
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Tags to be applied to all resources in the VPC."
  type        = map(string)
  default     = {}
}


# ***************************************
# Public Subnets
# ***************************************
variable "public_subnets" {
  description = "A list of IPv4 CIDR blocks for public subnets inside the VPC."
  type        = list(string)
  default     = []
}

variable "public_subnet_tags" {
  description = "Tags for public subnets."
  type        = map(string)
  default     = {}
}

# ***************************************
# Private Subnets
# ***************************************
variable "private_subnets" {
  description = "A list of IPv4 CIDR blocks for private subnets inside the VPC."
  type        = list(string)
  default     = []

}

variable "private_subnet_tags" {
  description = "Tags for private subnets."
  type        = map(string)
  default     = {}
}

# ***************************************
# Database Subnets
# ***************************************
variable "database_subnets" {
  description = "A list of IPv4 CIDR blocks for database subnets inside the VPC."
  type        = list(string)
  default     = []
}

# ***************************************
# NAT Gateway
# ***************************************
variable "single_nat_gateway" {
  description = "A boolean flag to use single NAT gateway for cost savings, otherwise NAT gateways will be created per AZ. Defaults to false."
  type        = bool
  default     = false
}

# ***************************************
# EKS Cluster
# ***************************************
variable "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = ""
}

variable "eks_cluster_version" {
  description = "Version of the EKS Cluster"
  type        = string
  default     = ""
}

variable "eks_log_types" {
  description = "A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
  default     = ["audit", "api", "authenticator", "controllerManager", "scheduler"]
}

variable "eks_authentication_mode" {
  description = "The authentication mode for the cluster. Valid values are `CONFIG_MAP`, `API` or `API_AND_CONFIG_MAP`"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

variable "eks_bootstrap_cluster_creator_admin_permissions" {
  description = "Whether or not to bootstrap the access config values to the cluster. For more information, see Amazon EKS Access Entries (https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html)"
  type        = bool
  default     = true
}

variable "eks_endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "eks_endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "eks_tags" {
  description = "Additional tags for all resources related to EKS"
  type        = map(string)
  default     = {}
}

# ***************************************
# KMS Key for EKS Secret Encryption
# ***************************************
variable "kms_key_usage" {
  description = "Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT, SIGN_VERIFY, or GENERATE_VERIFY_MAC"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "kms_enable_key_rotation" {
  description = "Specifies whether key rotation is enabled. For more information, see Rotating KMS Keys (https://docs.aws.amazon.com/kms/latest/developerguide/rotate-keys.html)"
  type        = bool
  default     = true
}

# ***************************************
# CloudWatch Log Group for EKS Control Plane logging
# ***************************************
variable "cloudwatch_retention_in_days" {
  description = "Duration to retain EKS control plane logs"
  type        = number
  default     = 90
}

# ***************************************
#  EKS Addons
# ***************************************
variable "eks_addon_preserve" {
  description = "Indicates if you want to preserve the created resources when deleting the EKS add-on"
  type        = bool
  default     = false
}

variable "eks_addon_resolve_conflicts_on_update" {
  description = "How to resolve field value conflicts for an Amazon EKS add-on if you've changed a value from the Amazon EKS default value. Valid values are NONE, OVERWRITE, and PRESERVE. For more information, see the UpdateAddon API Docs (https://docs.aws.amazon.com/eks/latest/APIReference/API_UpdateAddon.html)"
  type        = string
  default     = "OVERWRITE"
}

variable "eks_vpc_cni_version" {
  description = "Version of the VPC CNI cluster addon"
  type        = string
  default     = "v1.9.3-eksbuild.7"
}

variable "eks_coredns_version" {
  description = "Version of the Coredns cluster addon"
  type        = string
  default     = "v1.26.9-eksbuild.2"
}

variable "eks_kube_proxy_version" {
  description = "Version of the Kube-Proxy cluster addon"
  type        = string
  default     = "v1.15.1-eksbuild.1"
}

# ***************************************
#  aws-auth configmap
# ***************************************
variable "eks_aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "eks_aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "eks_aws_auth_accounts" {
  description = "List of account maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

# ***************************************
# Node Group
# ***************************************
variable "node_group_min_size" {
  description = "Minimum number of nodes in EKS cluster"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in EKS cluster"
  type        = number
  default     = 1
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in EKS cluster"
  type        = number
  default     = 1
}

variable "node_group_ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. See the [AWS documentation](https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType) for valid values"
  type        = string
  default     = "AL2_x86_64"
}

variable "node_group_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_group_disk_size" {
  description = "Disk size in GiB for nodes. Defaults to `20`."
  type        = number
  default     = null
}

variable "node_group_instance_types" {
  description = "Set of instance types associated with the EKS Node Group. Defaults to `[\"m5.large\"]`"
  type        = list(string)
  default     = ["m5.large"]
}

variable "node_group_max_unavailable_percentage" {
  description = " Desired max percentage of unavailable worker nodes during node group update."
  type        = number
  default     = 33
}
