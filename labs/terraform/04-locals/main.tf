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
  name_prefix = "${var.environment}-${var.application_name}"

  common_tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    ManagedBy   = "terraform"
  }
}

resource "local_file" "tags_file" {
  filename = "${path.module}/${local.name_prefix}-tags.txt"

  content = jsonencode(local.common_tags)
}