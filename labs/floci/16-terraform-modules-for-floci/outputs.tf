output "bucket_name" {
  value = module.secure_s3_bucket.bucket_name
}

output "bucket_arn" {
  value = module.secure_s3_bucket.bucket_arn
}

output "versioning_status" {
  value = module.secure_s3_bucket.versioning_status
}

output "encryption_algorithm" {
  value = module.secure_s3_bucket.encryption_algorithm
}