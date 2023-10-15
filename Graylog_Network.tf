# AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = local.vpc_name
  }
}

# AWS IGW
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = local.internet_gateway_name
  }
}

# AWS NAT Gateway
resource "aws_eip" "nat_elastic_ip-1" {
  tags = {
    Name = local.nat_elastic_ip-1_name
  }
}

resource "aws_nat_gateway" "nat_gateway-1" {
  allocation_id = aws_eip.nat_elastic_ip-1.id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    Name = local.nat_gateway-1_name
  }
}

resource "aws_eip" "nat_elastic_ip-2" {
  tags = {
    Name = local.nat_elastic_ip-2_name
  }
}

resource "aws_nat_gateway" "nat_gateway-2" {
  allocation_id = aws_eip.nat_elastic_ip-2.id
  subnet_id     = aws_subnet.public_subnets[1].id
  tags = {
    Name = local.nat_gateway-2_name
  }
}

resource "aws_eip" "nat_elastic_ip-3" {
  tags = {
    Name = local.nat_elastic_ip-3_name
  }
}

resource "aws_nat_gateway" "nat_gateway-3" {
  allocation_id = aws_eip.nat_elastic_ip-3.id
  subnet_id     = aws_subnet.public_subnets[2].id
  tags = {
    Name = local.nat_gateway-3_name
  }
}

# AWS Subnets and Route Tables
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.az_names, count.index)
  tags = {
    Name = join("-", [local.public_subnet_name, var.az_names[count.index]])
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.az_names, count.index)
  tags = {
    Name = join("-", [local.private_subnet_name, var.az_names[count.index]])
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "local.public_route_table_name"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table-1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway-1.id
  }
  tags = {
    Name = "local.private_route_table-1_name"
  }
}

resource "aws_route_table_association" "private_subnet_asso1" {
  subnet_id      = aws_subnet.private_subnets[0].id
  route_table_id = aws_route_table.private_route_table-1.id
}

resource "aws_route_table" "private_route_table-2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway-2.id
  }
  tags = {
    Name = "local.private_route_table-2_name"
  }
}

resource "aws_route_table_association" "private_subnet_asso2" {
  subnet_id      = aws_subnet.private_subnets[1].id
  route_table_id = aws_route_table.private_route_table-2.id
}

resource "aws_route_table" "private_route-table-3" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway-3.id
  }
  tags = {
    Name = "local.private_route_table-3_name"
  }
}

resource "aws_route_table_association" "private_subnet_asso3" {
  subnet_id      = aws_subnet.private_subnets[2].id
  route_table_id = aws_route_table.private_route-table-3.id
}