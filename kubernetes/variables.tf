variable "with_monitoring" {
  description = "Deploy monitoring stack (prometheus and grafana)?"
  type        = bool
  default     = false
}

# ***************************************
#  Argo CD
# ***************************************
variable "argo_url" {
  description = "Argo URL"
  type        = string
  default     = ""
}

variable "argo_chart_version" {
  description = "Version of Argo Helm chart"
  type        = string
  default     = ""
}

# ***************************************
#  Argo CD - Applications
# ***************************************
variable "repo_url" {
  description = "Github repo URL"
  type        = string
  default     = ""
}

variable "argo_apps_chart_version" {
  description = "Version of Argo Apps Helm chart"
  type        = string
  default     = ""
}

# ***************************************
#  AWS Load Balancer Controller
# ***************************************
variable "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = ""
}

variable "aws_lbc_chart_version" {
  description = "Version of AWS Load Balancer Controller Helm chart"
  type        = string
  default     = ""
}

# ***************************************
#  External DNS
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

variable "external_dns_chart_version" {
  description = "Version of External DNS Helm chart"
  type        = string
  default     = ""
}

# ***************************************
#  Cluster Autoscaler
# ***************************************
variable "cluster_autoscaler_chart_version" {
  description = "Version of Cluster Autoscaler Helm chart"
  type        = string
  default     = ""
}

# ***************************************
#  Metrics Server
# ***************************************
variable "metrics_server_chart_version" {
  description = "Version of Metrics Server Helm chart"
  type        = string
  default     = ""
}

# ***************************************
#  Prometheus
# ***************************************
variable "prometheus_chart_version" {
  description = "Version of Prometheus Helm chart"
  type        = string
  default     = ""
}

# ***************************************
#  Grafana
# ***************************************
variable "grafana_url" {
  description = "Grafana URL"
  type        = string
  default     = ""
}

variable "grafana_chart_version" {
  description = "Version of Grafana Helm chart"
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
