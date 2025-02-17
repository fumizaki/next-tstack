# # ECR リポジトリ
resource "aws_ecr_repository" "main" {
  name = "${var.project_name}-${var.environment}"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = "${var.project_name}-${var.environment}-ecr"
  }
}