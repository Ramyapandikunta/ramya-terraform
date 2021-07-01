provider "aws" {
  region     = "ap-south-1"

}

resource "aws_vpc" "vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "pub" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "Public"
  }
}

resource "aws_subnet" "pvt" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "Private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_eip" "Elastic-ip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.Elastic-ip.id
  subnet_id     = aws_subnet.pub.id

  tags = {
    Name = "NAT-GW"
  }
}

resource "aws_route_table" "pub-RT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pub-RT"
  }
}

resource "aws_route_table" "pvt-RT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "pvt-RT"
  }
}

resource "aws_route_table_association" "pub-sub" {
  subnet_id      = aws_subnet.pub.id
  route_table_id = aws_route_table.pub-RT.id
}

resource "aws_route_table_association" "pvt-sub" {
  subnet_id      = aws_subnet.pvt.id
  route_table_id = aws_route_table.pvt-RT.id
}

resource "aws_security_group" "terraform-SG" {
  name        = "terraform-SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-SG"
  }
}