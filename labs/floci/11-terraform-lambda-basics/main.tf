terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7"
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
    lambda = var.floci_endpoint
    iam    = var.floci_endpoint
    sts    = var.floci_endpoint
  }
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.environment}-${var.application_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = var.environment
    Application = var.application_name
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}

resource "aws_lambda_function" "hello_lambda" {
  function_name = "${var.environment}-${var.application_name}-hello-lambda"
  role          = aws_iam_role.lambda_role.arn

  runtime = "python3.13"
  handler = "lambda_function.handler"

  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  tags = {
    Environment = var.environment
    Application = var.application_name
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}