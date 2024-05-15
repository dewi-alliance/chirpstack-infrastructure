# ***************************************
# General
# ***************************************
variable "vpc_tags" {
  description = "Tags to be applied to all resources in the VPC."
  type        = map(string)
  default     = {}
}

variable "availability_zone_1" {
  description = "First AWS availability zone."
  type        = string
  default     = ""
}

variable "availability_zone_2" {
  description = "Second AWS availability zone."
  type        = string
  default     = ""
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

# ***************************************
# Public Subnets
# ***************************************
variable "public_subnet_1" {
  description = "The IPv4 CIDR block for the first public subnet."
  type        = string
  default     = ""
}

variable "public_subnet_2" {
  description = "The IPv4 CIDR block for the second public subnet."
  type        = string
  default     = ""
}

variable "vpc_public_subnet_tags" {
  description = "Tags for public subnets."
  type        = map(string)
  default     = {}
}

# ***************************************
# Private Subnets
# ***************************************
variable "private_subnet_1" {
  description = "The IPv4 CIDR block for the first private subnet."
  type        = string
  default     = ""
}

variable "private_subnet_2" {
  description = "The IPv4 CIDR block for the second private subnet."
  type        = string
  default     = ""
}

variable "vpc_private_subnet_tags" {
  description = "Tags for private subnets."
  type        = map(string)
  default     = {}
}

# ***************************************
# Database Subnets
# ***************************************
variable "database_subnet_1" {
  description = "The IPv4 CIDR block for the first database subnet."
  type        = string
  default     = ""
}

variable "database_subnet_2" {
  description = "The IPv4 CIDR block for the second database subnet."
  type        = string
  default     = ""
}
