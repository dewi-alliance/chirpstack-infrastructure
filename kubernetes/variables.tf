# ***************************************
#  Argo CD Helm Chart
# ***************************************
variable "argo_url" {
  description = "Argo URL"
  type        = string
  default     = ""
}

# ***************************************
#  AWS Load Balancer Controller Helm Chart
# ***************************************
variable "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = ""
}

# ***************************************
#  External DNS Helm Chart
# ***************************************
variable "zone_id" {
  description = "Route53 Zone ID"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region you're deploying to e.g., us-east-1"
  type        = string
  default     = ""
}

# ***************************************
#  K8s aws-auth configmap
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
