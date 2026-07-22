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
    s3             = var.floci_endpoint
    iam            = var.floci_endpoint
    secretsmanager = var.floci_endpoint
    sts            = var.floci_endpoint
  }
}

resource "aws_s3_bucket" "artifact_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Purpose     = "ci-artifact-storage"
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}

resource "aws_s3_bucket_versioning" "artifact_bucket" {
  bucket = aws_s3_bucket.artifact_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifact_bucket" {
  bucket = aws_s3_bucket.artifact_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "artifact_bucket" {
  bucket = aws_s3_bucket.artifact_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_iam_user" "ci_user" {
  name = var.ci_user_name

  tags = {
    Environment = var.environment
    Purpose     = "ci-artifact-upload"
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}

resource "aws_iam_policy" "artifact_bucket_policy" {
  name        = "${var.environment}-artifact-bucket-limited-access"
  description = "Least privilege access to CI artifact bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowListArtifactBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.artifact_bucket.arn
      },
      {
        Sid    = "AllowArtifactObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.artifact_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "ci_user_artifact_access" {
  user       = aws_iam_user.ci_user.name
  policy_arn = aws_iam_policy.artifact_bucket_policy.arn
}

resource "aws_secretsmanager_secret" "artifact_platform_metadata" {
  name        = var.secret_name
  description = "Metadata for local CI artifact platform"

  tags = {
    Environment = var.environment
    Application = var.application_name
    ManagedBy   = "terraform"
    Platform    = "floci"
  }
}

resource "aws_secretsmanager_secret_version" "artifact_platform_metadata" {
  secret_id = aws_secretsmanager_secret.artifact_platform_metadata.id

  secret_string = jsonencode({
    application = var.application_name
    bucket      = aws_s3_bucket.artifact_bucket.bucket
    ci_user     = aws_iam_user.ci_user.name
  })
}