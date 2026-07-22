variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "floci_endpoint" {
  type    = string
  default = "http://localhost:4566"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "bucket_name" {
  type    = string
  default = "devsecops-terraform-secure-s3"
}