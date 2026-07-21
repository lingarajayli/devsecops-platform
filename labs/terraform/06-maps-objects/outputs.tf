output "server_config_file" {
  value = local_file.server_config.filename
}

output "merged_tags" {
  value = local.merged_tags
}

output "server_config" {
  value = var.server_config
}