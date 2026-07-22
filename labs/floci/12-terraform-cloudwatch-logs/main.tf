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
    logs = var.floci_endpoint
    sts  = var.floci_endpoint
  }
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/${var.environment}/${var.application_name}/application"
  retention_in_days = var.retention_in_days

  tags = {
    Environment = var.environment
    Application = var.application_name
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}