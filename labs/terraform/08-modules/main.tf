terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

module "app_config" {
  source = "./modules/app_config"

  environment      = var.environment
  application_name = var.application_name
  replicas         = var.replicas
}