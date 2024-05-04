###########################################
# AWS PROVIDER
###########################################
provider "aws" {
  region = var.region
}

###########################################
# S3 BACKEND
###########################################
terraform {
  backend "s3" {
    bucket = "s3-finalproject-bekaiym"
    key    = "modules/networking/terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "terraform-state-lock"
  }
}


###########################################
# VPC
###########################################
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.name}-VPC"
  }
}

###########################################
# Public Subnets
###########################################
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  depends_on              = [aws_vpc.main]
  map_public_ip_on_launch = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.name}-public_subnet-${count.index + 1}"
    Type = "public"
  }
}

###########################################
# Private Subnets
###########################################
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  depends_on              = [aws_vpc.main]
  map_public_ip_on_launch = false

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.name}-private_subnet-${count.index + 1}"
    Type = "private"
  }
}

###########################################
# Internet Gateway
###########################################
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
}

###########################################
# Public Route Table
###########################################
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

###########################################
# Associate the public subnets with the public route table
###########################################
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnet[*].id)
  route_table_id = element(aws_route_table.public_route_table[*].id, count.index)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
}

###########################################
# Elastic IP
###########################################
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

###########################################
# NAT Gateway
###########################################
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id # NAT placed in Public Subnet 1
}

###########################################
# Private Route Table
###########################################
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

###########################################
# Associate the private subnets with the private route table
###########################################
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnet[*].id)
  route_table_id = element(aws_route_table.private_route_table[*].id, count.index)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
}
