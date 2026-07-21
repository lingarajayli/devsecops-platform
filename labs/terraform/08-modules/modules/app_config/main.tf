resource "local_file" "app_config" {
  filename = "${path.module}/../../${var.environment}-${var.application_name}-module-config.json"

  content = jsonencode({
    environment      = var.environment
    application_name = var.application_name
    replicas         = var.replicas
    managed_by       = "terraform-module"
  })
}