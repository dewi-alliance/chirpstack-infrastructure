# ***************************************
# General
# ***************************************
variable "vpc_tags" {
  description = "Tags to be applied to all resources in the VPC."
  type        = map(string)
  default     = {}
}

variable "availability_zones" {
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
  description = "Enable DNS support in the VPC? Defaults to true."
  type        = bool
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC. Defaults true."
  type        = bool
  default     = true
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
  description = "Use single NAT gateway for cost savings (otherwise NAT gateways will be created per AZ)? Defaults to false."
  type        = bool
  default     = false
}
