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

variable "secret_name" {
  type    = string
  default = "dev/flask-health-api/database"
}

variable "database_password" {
  type        = string
  sensitive   = true
  description = "Database password for local Floci demo. Pass using TF_VAR_database_password."
}