# ECR リポジトリ
resource "aws_ecr_repository" "webview" {
  name = "${var.environment}-${var.project_name}-webview"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = "${var.environment}-${var.project_name}-ecr-webview"
  }
}