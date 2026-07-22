output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "versioning_status" {
  value = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}

output "encryption_algorithm" {
  value = one(aws_s3_bucket_server_side_encryption_configuration.this.rule).apply_server_side_encryption_by_default[0].sse_algorithm
}