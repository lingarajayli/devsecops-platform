output "artifact_bucket_name" {
  value = aws_s3_bucket.artifact_bucket.bucket
}

output "artifact_bucket_arn" {
  value = aws_s3_bucket.artifact_bucket.arn
}

output "ci_user_name" {
  value = aws_iam_user.ci_user.name
}

output "ci_user_arn" {
  value = aws_iam_user.ci_user.arn
}

output "iam_policy_arn" {
  value = aws_iam_policy.artifact_bucket_policy.arn
}

output "secret_name" {
  value = aws_secretsmanager_secret.artifact_platform_metadata.name
}

output "versioning_status" {
  value = aws_s3_bucket_versioning.artifact_bucket.versioning_configuration[0].status
}

output "encryption_algorithm" {
  value = one(aws_s3_bucket_server_side_encryption_configuration.artifact_bucket.rule).apply_server_side_encryption_by_default[0].sse_algorithm
}