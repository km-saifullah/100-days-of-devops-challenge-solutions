terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    ec2            = "http://aws:4566"
    apigateway     = "http://aws:4566"
    cloudformation = "http://aws:4566"
    cloudwatch     = "http://aws:4566"
    dynamodb       = "http://aws:4566"
    es             = "http://aws:4566"
    firehose       = "http://aws:4566"
    iam            = "http://aws:4566"
    kinesis        = "http://aws:4566"
    lambda         = "http://aws:4566"
    route53        = "http://aws:4566"
    redshift       = "http://aws:4566"
    s3             = "http://aws:4566"
    secretsmanager = "http://aws:4566"
    ses            = "http://aws:4566"
    sns            = "http://aws:4566"
    sqs            = "http://aws:4566"
    ssm            = "http://aws:4566"
    stepfunctions  = "http://aws:4566"
    sts            = "http://aws:4566"
    rds            = "http://aws:4566"
  }
}

resource "aws_vpc" "datacenter_priv_vpc" {
  cidr_block = var.KKE_VPC_CIDR

  tags = {
    Name = "datacenter-priv-vpc"
  }
}

resource "aws_subnet" "datacenter_priv_subnet" {
  vpc_id                  = aws_vpc.datacenter_priv_vpc.id
  cidr_block              = var.KKE_SUBNET_CIDR
  map_public_ip_on_launch = false

  tags = {
    Name = "datacenter-priv-subnet"
  }
}

resource "aws_security_group" "datacenter_priv_sg" {
  name        = "datacenter-priv-sg"
  description = "Security group for private datacenter EC2 instance"
  vpc_id      = aws_vpc.datacenter_priv_vpc.id

  ingress {
    description = "Allow access only from within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.KKE_VPC_CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.KKE_VPC_CIDR]
  }

  tags = {
    Name = "datacenter-priv-sg"
  }
}

resource "aws_instance" "datacenter_priv_ec2" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.datacenter_priv_subnet.id

  vpc_security_group_ids = [
    aws_security_group.datacenter_priv_sg.id
  ]

  associate_public_ip_address = false

  lifecycle {
    ignore_changes = [
      vpc_security_group_ids
    ]
  }

  tags = {
    Name = "datacenter-priv-ec2"
  }
}