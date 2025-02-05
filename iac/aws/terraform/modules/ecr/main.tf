# ECRリポジトリを作成
# ECRリポジトリ：コンテナイメージを保存するためのリポジトリ
resource "aws_ecr_repository" "app" {
  name                 = "${var.project_name}-${var.environment}"
  # イメージタグのミュータビリティを指定
  # * MUTABLE: イメージタグを上書き可能
  image_tag_mutability = "MUTABLE"

  # イメージスキャンを定義
  image_scanning_configuration {
    scan_on_push = true # イメージプッシュ時にスキャンを実行
  }

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-ecr"
    Environment = var.environment
  }
}

# ECRリポジトリのライフサイクルポリシーを作成
# ECRリポジトリのライフサイクルポリシー：イメージの保存期間や削除条件を定義
resource "aws_ecr_lifecycle_policy" "app" {
  # ECRリポジトリを指定
  repository = aws_ecr_repository.app.name

  # ライフサイクルポリシーを指定
  policy = jsonencode({
    rules = [
      {
        # ルールの優先度
        rulePriority = 1 # 小さいほど優先度が高い 
        description  = "Keep last 5 images"
        # イメージの選択条件を指定
        selection = {
          tagStatus   = "any" # 任意のタグ
          countType   = "imageCountMoreThan" # イメージ数が指定した数より多い
          countNumber = 5 # 5つより多い
        }
        # アクションを指定
        action = {
          type = "expire" # イメージの削除
        }
      }
    ]
  })
}