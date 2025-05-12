output "webview_ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.webview.repository_url
}

output "webview_ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.webview.name
}