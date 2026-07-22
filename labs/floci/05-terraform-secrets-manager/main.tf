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
    secretsmanager = var.floci_endpoint
    sts            = var.floci_endpoint
  }
}

resource "aws_secretsmanager_secret" "app_db_password" {
  name        = var.secret_name
  description = "Database password secret for Flask Health API"

  tags = {
    Environment = var.environment
    Application = var.application_name
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}

resource "aws_secretsmanager_secret_version" "app_db_password" {
  secret_id = aws_secretsmanager_secret.app_db_password.id

  secret_string = jsonencode({
    username = "flask_app"
    password = var.database_password
  })
}