# ***************************************
# Module Data
# ***************************************
locals {
  number_of_ngws = min(length(var.availability_zones), length(var.private_subnets))
}

# ***************************************
# VPC
# ***************************************
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  tags = merge(
    {
      Name = var.vpc_name
    },
    var.vpc_tags,
  )
}

# ***************************************
# Public Subnets
# ***************************************
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.public_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    {
      Name = format("${var.vpc_name}-public-subnet-%s", element(var.availability_zones, count.index))
    },
    var.vpc_tags,
    var.public_subnet_tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.vpc_name}-public-subnet-rt"
    },
    var.vpc_tags,
  )
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"

  timeouts {
    create = "5m"
  }
}

# ***************************************
# Private Subnets
# ***************************************
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    {
      Name = format("${var.vpc_name}-private-subnet-%s", element(var.availability_zones, count.index))
    },
    var.vpc_tags,
    var.private_subnet_tags
  )
}

# Unless 1 NAT Gateway is requested, there will be a number of NAT
# Gateways corresponding to the lesser of private subnets and AZs.
resource "aws_route_table" "private" {
  count = var.single_nat_gateway ? 1 : local.number_of_ngws

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = format("${var.vpc_name}-private-rt-%s", element(var.availability_zones, count.index))
    },
    var.vpc_tags,
  )
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(
    aws_route_table.private[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route" "private_nat_gateway" {
  count = var.single_nat_gateway ? 1 : local.number_of_ngws

  route_table_id         = element(aws_route_table.private[*].id, count.index)
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"

  timeouts {
    create = "5m"
  }
}

# ***************************************
# Database Subnets
# ***************************************
resource "aws_subnet" "database" {
  count = length(var.database_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.database_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    {
      Name = format("${var.vpc_name}-database-subnet-%s", element(var.availability_zones, count.index))
    },
    var.vpc_tags,
  )
}

resource "aws_route_table" "database" {
  count = length(var.database_subnets)

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = format("${var.vpc_name}-database-rt-%s", element(var.availability_zones, count.index))
    },
    var.vpc_tags,
  )
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnets)

  subnet_id = element(aws_subnet.database[*].id, count.index)
  route_table_id = element(
    aws_route_table.database[*].id,
    count.index,
  )
}

resource "aws_db_subnet_group" "database" {
  name        = "${var.vpc_name}-database-subnet-group"
  description = "Database subnet group for ${var.vpc_name}"
  subnet_ids  = aws_subnet.database[*].id

  tags = merge(
    {
      Name = "${var.vpc_name}-database-subnet-group"
    },
    var.vpc_tags,
  )
}

################################################################################
# Internet Gateway
################################################################################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.vpc_name}-igw"
    },
    var.vpc_tags,
  )
}

################################################################################
# NAT Gateway
################################################################################
resource "aws_eip" "nat" {
  count = var.single_nat_gateway ? 1 : local.number_of_ngws

  domain = "vpc"

  tags = merge(
    {
      Name = format(
        "${var.vpc_name}-ngw-eip-%s",
      element(var.availability_zones, var.single_nat_gateway ? 0 : count.index))
    },
    var.vpc_tags,
  )

  depends_on = [
    aws_internet_gateway.this,
  ]
}

resource "aws_nat_gateway" "this" {
  count = var.single_nat_gateway ? 1 : length(var.availability_zones)

  allocation_id = element(
    aws_eip.nat[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
  subnet_id = element(
    aws_subnet.public[*].id,
    count.index,
  )

  tags = merge(
    {
      Name = format(
        "${var.vpc_name}-ngw-%s",
        element(aws_subnet.public[*].id, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.vpc_tags,
  )

  depends_on = [
    aws_eip.nat,
    aws_internet_gateway.this,
    aws_subnet.public
  ]
}
