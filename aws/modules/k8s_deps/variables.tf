variable "aws_region" {
  description = "AWS region for infrastructure."
  type        = string
  default     = ""
}

variable "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = ""
}

variable "whitelisted_cidrs" {
  description = "The IPv4 CIDR blocks for whitelisted IPs accessing Chirpstack, Argo, Grafana, and MQTT"
  type        = list(string)
  default     = []
}
