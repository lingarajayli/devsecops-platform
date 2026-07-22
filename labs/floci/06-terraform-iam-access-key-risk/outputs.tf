output "iam_user_name" {
  value = aws_iam_user.ci_user.name
}

output "access_key_id" {
  value = aws_iam_access_key.ci_user_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.ci_user_key.secret
  sensitive = true
}