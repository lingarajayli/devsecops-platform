terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

locals {
  instance_type = var.environment == "prod" ? "t3.medium" : "t3.micro"
  monitoring    = var.environment == "prod" ? true : false
  replicas      = var.environment == "prod" ? 3 : 1
}

resource "local_file" "environment_config" {
  filename = "${path.module}/${var.environment}-environment-config.json"

  content = jsonencode({
    application   = var.application_name
    environment   = var.environment
    instance_type = local.instance_type
    monitoring    = local.monitoring
    replicas      = local.replicas
  })
}