terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = var.floci_endpoint
    sts = var.floci_endpoint
  }
}

resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-${var.application_name}-app-sg"
  description = "Security group for Flask Health API app server"

  tags = {
    Name        = "${var.environment}-${var.application_name}-app-sg"
    Environment = var.environment
    Application = var.application_name
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.app_sg.id

  description = "Allow HTTP traffic"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_ipv4   = var.allowed_cidr
}

resource "aws_vpc_security_group_ingress_rule" "allow_app_port" {
  security_group_id = aws_security_group.app_sg.id

  description = "Allow Flask app traffic"
  ip_protocol = "tcp"
  from_port   = 5000
  to_port     = 5000
  cidr_ipv4   = var.allowed_cidr
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.app_sg.id

  description = "Allow outbound traffic"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}