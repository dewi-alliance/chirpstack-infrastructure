# ***************************************
# Module-wide locals
# ***************************************
locals {
  availability_zones = [var.availability_zone_1, var.availability_zone_2]
  public_subnets     = [var.public_subnet_1, var.public_subnet_2]
  private_subnets    = [var.private_subnet_1, var.private_subnet_2]
  database_subnets   = [var.database_subnet_1, var.database_subnet_2]
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
  count = length(local.public_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(local.public_subnets, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = merge(
    {
      Name = format("${var.vpc_name}-public-subnet-%s", element(local.availability_zones, count.index))
    },
    var.vpc_tags,
    var.vpc_public_subnet_tags
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
  count = length(local.public_subnets)

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
  count = length(local.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(local.private_subnets, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = merge(
    {
      Name = format("${var.vpc_name}-private-subnet-%s", element(local.availability_zones, count.index))
    },
    var.vpc_tags,
    var.vpc_private_subnet_tags
  )
}

resource "aws_route_table" "private" {
  count = length(local.private_subnets)

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = format("${var.vpc_name}-private-rt-%s", element(local.availability_zones, count.index))
    },
    var.vpc_tags,
  )
}

resource "aws_route_table_association" "private" {
  count = length(local.private_subnets)

  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(
    aws_route_table.private[*].id,
    count.index,
  )
}

resource "aws_route" "private_nat_gateway" {
  count = length(local.private_subnets)

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
  count = length(local.database_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(local.database_subnets, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = merge(
    {
      Name = format("${var.vpc_name}-database-subnet-%s", element(local.availability_zones, count.index))
    },
    var.vpc_tags,
  )
}

resource "aws_route_table" "database" {
  count = length(local.database_subnets)

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = format("${var.vpc_name}-database-rt-%s", element(local.availability_zones, count.index))
    },
    var.vpc_tags,
  )
}

resource "aws_route_table_association" "database" {
  count = length(local.database_subnets)

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
  count = length(local.database_subnets)

  domain = "vpc"

  tags = merge(
    {
      Name = format("${var.vpc_name}-ngw-eip-%s", element(local.availability_zones, count.index))
    },
    var.vpc_tags,
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count = length(local.database_subnets)

  allocation_id = element(
    aws_eip.nat[*].id,
    count.index,
  )
  subnet_id = element(
    aws_subnet.public[*].id,
    count.index,
  )

  tags = merge(
    {
      "Name" = format(
        "${var.vpc_name}-%s",
        element(aws_subnet.public[*].id, count.index),
      )
    },
    var.vpc_tags,
  )

  depends_on = [aws_internet_gateway.this]
}
