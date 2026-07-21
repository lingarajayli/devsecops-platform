terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "server_inventory" {
  filename = "${path.module}/${var.environment}-inventory.txt"

  content = <<EOT
Environment: ${var.environment}
Application: ${var.application_name}
Owner: ${var.owner}
Instance Count: ${var.instance_count}
EOT
}