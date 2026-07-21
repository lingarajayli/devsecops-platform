output "inventory_file_path" {
  description = "Path of the generated inventory file"
  value       = local_file.server_inventory.filename
}

output "application_summary" {
  description = "Application deployment summary"
  value       = "${var.application_name} running in ${var.environment} with ${var.instance_count} instance(s)"
}