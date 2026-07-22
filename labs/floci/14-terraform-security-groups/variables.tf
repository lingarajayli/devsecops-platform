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

variable "application_name" {
  type    = string
  default = "flask-health-api"
}

variable "allowed_cidr" {
  type    = string
  default = "10.0.0.0/16"
}