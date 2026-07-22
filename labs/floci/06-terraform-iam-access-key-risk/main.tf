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
    iam = var.floci_endpoint
    sts = var.floci_endpoint
  }
}

resource "aws_iam_user" "ci_user" {
  name = var.iam_user_name

  tags = {
    Environment = var.environment
    Purpose     = "ci-authentication-demo"
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}

resource "aws_iam_access_key" "ci_user_key" {
  user = aws_iam_user.ci_user.name
}