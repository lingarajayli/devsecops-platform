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
    ssm = var.floci_endpoint
    sts = var.floci_endpoint
  }
}

resource "aws_ssm_parameter" "app_environment" {
  name        = "/${var.environment}/${var.application_name}/environment"
  description = "Application environment name"
  type        = "String"
  value       = var.environment

  tags = {
    Environment = var.environment
    Application = var.application_name
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}

resource "aws_ssm_parameter" "app_log_level" {
  name        = "/${var.environment}/${var.application_name}/log-level"
  description = "Application log level"
  type        = "String"
  value       = var.log_level

  tags = {
    Environment = var.environment
    Application = var.application_name
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}

resource "aws_ssm_parameter" "app_replicas" {
  name        = "/${var.environment}/${var.application_name}/replicas"
  description = "Application replica count"
  type        = "String"
  value       = tostring(var.replicas)

  tags = {
    Environment = var.environment
    Application = var.application_name
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}