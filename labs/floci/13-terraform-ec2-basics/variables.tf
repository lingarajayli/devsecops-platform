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

variable "ami_id" {
  type    = string
  default = "ami-12345678"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}