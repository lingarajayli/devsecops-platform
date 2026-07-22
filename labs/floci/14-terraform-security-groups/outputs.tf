output "security_group_id" {
  value = aws_security_group.app_sg.id
}

output "security_group_name" {
  value = aws_security_group.app_sg.name
}

output "allowed_cidr" {
  value = var.allowed_cidr
}