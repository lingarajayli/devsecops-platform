output "environment_parameter_name" {
  value = aws_ssm_parameter.app_environment.name
}

output "log_level_parameter_name" {
  value = aws_ssm_parameter.app_log_level.name
}

output "replicas_parameter_name" {
  value = aws_ssm_parameter.app_replicas.name
}