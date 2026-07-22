output "log_group_name" {
  value = aws_cloudwatch_log_group.app_logs.name
}

output "retention_in_days" {
  value = aws_cloudwatch_log_group.app_logs.retention_in_days
}