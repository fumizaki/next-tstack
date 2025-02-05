# ECSタスク定義の作成
# ECSタスク定義：コンテナイメージ、CPU、メモリ、環境変数、ログ出力、ヘルスチェックなどの設定を定義します。
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project_name}-${var.environment}-task"
  # 要求される互換性を指定
  # * FARGATE: Fargateタスクのみを実行
  # * EC2: EC2インスタンスでのタスクのみを実行
  requires_compatibilities = ["FARGATE"]
  # タスク定義のネットワークモードを指定
  # * awsvpc: タスクがVPC内のネットワークを使用
  network_mode             = "awsvpc"
  # タスクのCPUを指定
  cpu                      = var.task_cpu
  # タスクのメモリを指定
  memory                   = var.task_memory
  # タスクの実行ロールを指定
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  # タスクのタスクロールを指定
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  # コンテナ定義を指定
  container_definitions = jsonencode([{
    name  = "${var.project_name}-container"
    # コンテナイメージを指定
    image = "${var.ecr_repository_url}:${var.container_image_tag}"
    
    # ポートマッピングを指定
    # * コンテナが使用するポートとホストが使用するポートを指定
    # ** コンテナが使用するポート: コンテナがリクエストを受け付けるポート
    # ** ホストが使用するポート: ホストがリクエストを受け付けるポート
    portMappings = [{
      containerPort = var.container_port # コンテナが使用するポート
      hostPort      = var.container_port # ホストが使用するポート
      protocol      = "tcp" # プロトコル
    }]

    # 環境変数を指定
    # * コンテナに渡す環境変数を指定
    environment = var.environment_variables

    # ログ出力を指定
    logConfiguration = {
      # ログドライバを指定
      logDriver = "awslogs" # CloudWatch Logs
      # オプションを指定
      options = {
        awslogs-group         = var.log_group_name # ロググループ名
        awslogs-region        = var.aws_region # リージョン
        awslogs-stream-prefix = "ecs" # ストリーム名のプレフィックス
      }
    }

    # ヘルスチェックを指定
    healthCheck = {
      command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port}/ || exit 1"] # ヘルスチェックコマンド
      interval    = 30 # ヘルスチェックの間隔
      timeout     = 5 # タイムアウト時間
      retries     = 3 # リトライ回数
      startPeriod = 60 # 開始時間
    }
  }])

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-task-definition"
    Environment = var.environment
  }
}

# ECSタスクを実行するIAMロールを作成
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project_name}-${var.environment}-execution-role"

  # ロールが引き受ける信頼ポリシーを指定
  # * 信頼ポリシー: ロールが引き受けるアクションを指定
  assume_role_policy = jsonencode({
    Version = "2012-10-17" # ポリシーバージョン
    Statement = [
      {
        Action = "sts:AssumeRole" # 実行するアクション
        Effect = "Allow" # 許可
        Principal = {
          Service = "ecs-tasks.amazonaws.com" # サービス
        }
      }
    ]
  })
}

# IAMロールにポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  # ECSタスク実行ロールのARN
  role       = aws_iam_role.ecs_execution_role.name
  # AmazonECSTaskExecutionRolePolicyポリシーのARN
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAMロールのポリシーを作成
resource "aws_iam_role_policy" "ecs_execution_role_ecr_policy" {
  name = "${var.project_name}-${var.environment}-ecr-policy"
  # ECSタスク実行ロールのARN
  role = aws_iam_role.ecs_execution_role.id

  # ポリシードキュメントを指定
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow" # 許可
        Action = [
          "ecr:GetAuthorizationToken", # 認証トークンの取得
          "ecr:BatchCheckLayerAvailability", # レイヤーの可用性のバッチチェック
          "ecr:GetDownloadUrlForLayer", # レイヤーのダウンロードURLの取得
          "ecr:BatchGetImage" # イメージのバッチ取得
        ]
        # リソースを指定
        Resource = "*" # すべてのリソース
      }
    ]
  })
}

# IAMロールを作成
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project_name}-${var.environment}-task-role"

  # 信頼ポリシーを指定
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}