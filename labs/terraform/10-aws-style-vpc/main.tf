terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

locals {
  name_prefix = "${var.environment}-${var.application_name}"

  vpc_design = {
    name = "${local.name_prefix}-vpc"
    cidr = var.vpc_cidr

    public_subnets  = var.public_subnets
    private_subnets = var.private_subnets

    tags = {
      Environment = var.environment
      Application = var.application_name
      ManagedBy   = "terraform"
      Purpose     = "aws-style-local-design"
    }
  }
}

resource "local_file" "vpc_design" {
  filename = "${path.module}/${local.name_prefix}-vpc-design.json"
  content  = jsonencode(local.vpc_design)
}