terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  shared_credentials_files = ["/home/boibandidoorigins/.aws/credentials"]
  region                   = "sa-east-1"
}

resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "tutorial_vpc"
  }
}

resource "aws_subnet" "this" {
  depends_on = [aws_internet_gateway.this]

  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "sa-east-1a"
  tags = {
    Name = "tutorial_subnet"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "tutorial_igw"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "tutorial_rt"
  }
}

resource "aws_route_table_association" "this_assoc" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

resource "aws_key_pair" "this" {
  key_name   = "tutorial_ec2_key"
  public_key = file("~/.ssh/aws-test.pub")
  tags = {
    Name = "tutorial_ec2_key"
  }
}

resource "aws_instance" "this" {
  ami                    = "ami-0af6e9042ea5a4e3e"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.this.key_name
  subnet_id              = aws_subnet.this.id
  vpc_security_group_ids = [aws_security_group.allow_api.id]
  depends_on             = [aws_internet_gateway.this]
  tags = {
    Name = "tutorial_ec2"
  }
}