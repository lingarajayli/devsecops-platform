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
  merged_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Application = var.application_name
    }
  )
}

resource "local_file" "server_config" {
  filename = "${path.module}/${var.environment}-server-config.json"

  content = jsonencode({
    application   = var.application_name
    environment   = var.environment
    server_config = var.server_config
    tags          = local.merged_tags
  })
}