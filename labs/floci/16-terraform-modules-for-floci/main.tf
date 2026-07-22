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
    s3  = var.floci_endpoint
    sts = var.floci_endpoint
  }
}

module "secure_s3_bucket" {
  source = "./modules/secure_s3_bucket"

  bucket_name      = var.bucket_name
  environment      = var.environment
  application_name = var.application_name
}