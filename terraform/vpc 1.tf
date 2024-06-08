# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Nat Gateway
#  * Route Table
#

resource "aws_vpc" "devops-vpc" {
  cidr_block           = "10.65.16.0/23"
  enable_dns_hostnames = "true"
  tags = {
    Name = "devops-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "devops-publicsubnet-1" {
  vpc_id            = aws_vpc.devops-vpc.id
  cidr_block        = "10.65.16.0/26"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "devops-publicsubnet-1"
  }
}

resource "aws_subnet" "devops-publicsubnet-2" {
  vpc_id            = aws_vpc.devops-vpc.id
  cidr_block        = "10.65.17.0/26"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "devops-publicsubnet-2"
  }
}
###

resource "aws_subnet" "devops-privatesubnet-1" {
  vpc_id            = aws_vpc.devops-vpc.id
  cidr_block        = "10.65.16.64/26"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "devops-privatesubnet-1"
  }
}

resource "aws_subnet" "devops-privatesubnet-2" {
  vpc_id            = aws_vpc.devops-vpc.id
  cidr_block        = "10.65.16.128/26"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "devops-privatesubnet-2"
  }
}

resource "aws_subnet" "devops-privatesubnet-3" {
  vpc_id            = aws_vpc.devops-vpc.id
  cidr_block        = "10.65.17.64/26"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "devops-privatesubnet-3"
  }
}

resource "aws_subnet" "devops-privatesubnet-4" {
  vpc_id            = aws_vpc.devops-vpc.id
  cidr_block        = "10.65.17.128/26"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "devops-privatesubnet-4"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops-vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_eip" "devops-nat1" {
  vpc = true

  tags = {
    Name = "devops-nat1"
  }
}

resource "aws_eip" "devops-nat2" {
  vpc = true

  tags = {
    Name = "devops-nat2"
  }
}

resource "aws_nat_gateway" "devops-nat1" {
  allocation_id = aws_eip.devops-nat1.id
  subnet_id     = aws_subnet.devops-publicsubnet-1.id

  tags = {
    Name = "devops-nat1"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "devops-nat2" {
  allocation_id = aws_eip.devops-nat2.id
  subnet_id     = aws_subnet.devops-publicsubnet-2.id

  tags = {
    Name = "devops-nat2"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "devops-privateAZ-1" {
  vpc_id = aws_vpc.devops-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.devops-nat1.id
  }
  tags = {
    Name = "devops-privateAZ-1"
  }
}

resource "aws_route_table" "devops-privateAZ-2" {
  vpc_id = aws_vpc.devops-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.devops-nat2.id
  }
  tags = {
    Name = "devops-privateAZ-2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.devops-vpc.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public"
  }
}
resource "aws_route_table_association" "devops-privatesubnet-1" {
  subnet_id      = aws_subnet.devops-privatesubnet-1.id
  route_table_id = aws_route_table.devops-privateAZ-1.id
}

resource "aws_route_table_association" "devops-privatesubnet-2" {
  subnet_id      = aws_subnet.devops-privatesubnet-2.id
  route_table_id = aws_route_table.devops-privateAZ-2.id
}

resource "aws_route_table_association" "devops-privatesubnet-3" {
  subnet_id      = aws_subnet.devops-privatesubnet-3.id
  route_table_id = aws_route_table.devops-privateAZ-1.id
}

resource "aws_route_table_association" "devops-privatesubnet-4" {
  subnet_id      = aws_subnet.devops-privatesubnet-4.id
  route_table_id = aws_route_table.devops-privateAZ-2.id
}

resource "aws_route_table_association" "devops-publicsubnet-1" {
  subnet_id      = aws_subnet.devops-publicsubnet-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "devops-publicsubnet-2" {
  subnet_id      = aws_subnet.devops-publicsubnet-2.id
  route_table_id = aws_route_table.public.id
}
