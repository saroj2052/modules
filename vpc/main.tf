

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true #gives you an internal domain name
  enable_dns_hostnames = true #gives you an internal host name
  enable_classiclink   = false
  instance_tenancy     = "default"

  tags = {
    Name = "${local.environment}-vpc"
  }
}
resource "aws_subnet" "aws_pub_subnet" {
  vpc_id     = aws_vpc.vpc.id
  count      = var.subnet_count
  availability_zone = data.aws_availability_zones.myaz.names[count.index]
  map_public_ip_on_launch =true
  cidr_block = element(var.aws_subnets, count.index) #"10.0.1.0/24"

  tags = {
    Name = "${local.environment}-pub-subnet-${count.index}"
  }
}

resource "aws_subnet" "aws_priv_subnet" {
  vpc_id     = aws_vpc.vpc.id
  count      = var.subnet_count
  cidr_block = element(var.aws_subnets, count.index + 2) #"10.0.1.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.environment}-priv-subnet-${count.index}"
  }
}

resource "aws_route_table" "rt_pub" {
  vpc_id = aws_vpc.vpc.id

  route = []

  tags = {
    Name = "${local.environment}-rt}"
  }
}

resource "aws_route" "route_pub" {
  route_table_id         = aws_route_table.rt_pub.id
  destination_cidr_block = "0.0.0.0/0"
  #   vpc_peering_connection_id = "pcx-45ff3dc1"
  gateway_id = aws_internet_gateway.igw.id
  depends_on = [aws_route_table.rt_pub]
}

resource "aws_route_table_association" "rta" {
  count          = var.subnet_count
  subnet_id      = element(aws_subnet.aws_pub_subnet.*.id, count.index)
  route_table_id = aws_route_table.rt_pub.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.environment}-igw}"
  }
}


resource "aws_eip" "aeip" {
#   instance = aws_instance.web.id
  vpc      = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.aeip.id
#   count =1
  subnet_id     = aws_subnet.aws_pub_subnet[0].id

  tags = {
    Name = "${local.environment}-nat}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # gateway_id = aws_internet_gateway.example.id
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  # route {
  #   ipv6_cidr_block        = "::/0"
  #   egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  # }

  tags = {
    Name = "${local.environment}-priv-rt}"
  }
}

resource "aws_route_table_association" "prta" {
  count =var.subnet_count
  subnet_id      = element(aws_subnet.aws_priv_subnet.*.id,count.index)
  route_table_id = aws_route_table.priv_rt.id
}
