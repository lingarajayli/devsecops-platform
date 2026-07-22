output "bucket_name" {
  value = aws_s3_bucket.app_artifacts.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.app_artifacts.arn
}

output "iam_user_name" {
  value = aws_iam_user.ci_user.name
}

output "iam_user_arn" {
  value = aws_iam_user.ci_user.arn
}

output "policy_arn" {
  value = aws_iam_policy.s3_limited_access.arn
}