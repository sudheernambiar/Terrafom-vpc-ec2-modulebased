#Create VPC
resource "aws_vpc" "VPC" {
  cidr_block            = var.cidr_block
  instance_tenancy      = "default"
  enable_dns_support    = true
  enable_dns_hostnames  = true


  tags = {
    Name  = "${var.project}-VPC-${var.level}"
    Owner = var.owner
    env   = var.level
  }
}
#Create PublicSubnet1
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = cidrsubnet(var.cidr_block, var.bits, 0)
  availability_zone = data.aws_availability_zones.my_az.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name  = "${var.project}-PubSub1-${var.level}"
    Owner = var.owner
    env   = var.level
  }
}

#Create PublicSubnet2
resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = cidrsubnet(var.cidr_block, var.bits, 1)
  availability_zone = data.aws_availability_zones.my_az.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name  = "${var.project}-PubSub2-${var.level}"
    Owner = var.owner
    env   = var.level
  }
}

#Create PublicSubnet3
resource "aws_subnet" "public_subnet3" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = cidrsubnet(var.cidr_block, var.bits, 2)
  availability_zone = data.aws_availability_zones.my_az.names[2]
  map_public_ip_on_launch = true
  tags = {
    Name  = "${var.project}-PubSub3-${var.level}"
    Owner = var.owner
    env   = var.level
  }
}
#Create PrivateSubnet1
resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = cidrsubnet(var.cidr_block, var.bits, 3)
  availability_zone = data.aws_availability_zones.my_az.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name  = "${var.project}-PrivSub1-${var.level}"
    Owner = var.owner
    env   = var.level
  }
}
#Create PrivateSubnet2
resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = cidrsubnet(var.cidr_block, var.bits, 4)
  availability_zone = data.aws_availability_zones.my_az.names[1]
  map_public_ip_on_launch = false
  tags = {
    Name  = "${var.project}-PrivSub2-${var.level}"
    Owner = var.owner
    env   = var.level
  }
}
#Create PrivateSubnet3
resource "aws_subnet" "private_subnet3" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = cidrsubnet(var.cidr_block, var.bits, 5)
  availability_zone = data.aws_availability_zones.my_az.names[2]
  map_public_ip_on_launch = false
  tags = {
    Name  = "${var.project}-PrivSub2-${var.level}"
    Owner = var.owner
    env   = var.level
  }
}

#Allocate a EIP
resource "aws_eip" "nat-eip" {
  vpc              = true
  tags = {
    Name  = "${var.project}-EIP-${var.level}"
    Owner = var.owner
    env   = var.level
  } 
}
#Create Internet gateway
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.VPC.id
  tags = {
    Name  = "${var.project}-IGW-${var.level}"
    Owner = var.owner
    env   = var.level
  }
}
#Create NAT Gateway
resource "aws_nat_gateway" "NAT-GW" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name  = "${var.project}-NAT-GW-${var.level}"
    Owner = var.owner
    env   = var.level
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [ aws_internet_gateway.IGW ]
}
#Create Public Route Table
resource "aws_route_table" "PubRT" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name  = "${var.project}-PubRT-${var.level}"
    Owner = var.owner
    env   = var.level
  }
}
#Create Private Route Table
resource "aws_route_table" "PrivRT" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT-GW.id
  }

  tags = {
    Name  = "${var.project}-PrivRT-${var.level}"
    Owner = var.owner
    env   = var.level
  }
}
#Route Table Associations Public subnets
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.PubRT.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.PubRT.id
}

resource "aws_route_table_association" "public31" {
  subnet_id      = aws_subnet.public_subnet3.id
  route_table_id = aws_route_table.PubRT.id
}
##Route Table Associations private subnets
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.PrivRT.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.PrivRT.id
}
resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.PrivRT.id
}