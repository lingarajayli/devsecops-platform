output "repository_name" {
  value = aws_ecr_repository.app_repository.name
}

output "repository_arn" {
  value = aws_ecr_repository.app_repository.arn
}

output "repository_url" {
  value = aws_ecr_repository.app_repository.repository_url
}

output "image_tag_mutability" {
  value = aws_ecr_repository.app_repository.image_tag_mutability
}