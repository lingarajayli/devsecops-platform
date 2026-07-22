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

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    iam = var.floci_endpoint
    sts = var.floci_endpoint
    s3  = var.floci_endpoint
  }
}

resource "aws_s3_bucket" "app_artifacts" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}

resource "aws_iam_user" "ci_user" {
  name = var.iam_user_name

  tags = {
    Environment = var.environment
    Purpose     = "ci-artifact-upload"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_policy" "s3_limited_access" {
  name        = "${var.environment}-s3-artifact-limited-access"
  description = "Least privilege policy for CI user to access only one S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowListSpecificBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.app_artifacts.arn
      },
      {
        Sid    = "AllowObjectReadWrite"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.app_artifacts.arn}/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "ci_user_s3_access" {
  user       = aws_iam_user.ci_user.name
  policy_arn = aws_iam_policy.s3_limited_access.arn
}