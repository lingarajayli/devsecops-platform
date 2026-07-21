output "environment_config" {
  value = {
    environment   = var.environment
    instance_type = local.instance_type
    monitoring    = local.monitoring
    replicas      = local.replicas
  }
}