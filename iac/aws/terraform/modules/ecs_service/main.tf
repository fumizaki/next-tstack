# セキュリティグループを作成
# * セキュリティグループ: インスタンスに許可するトラフィックを制御するためのリソース
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project_name}-${var.environment}-ecs-tasks-sg"
  description = "Allow inbound access from the ALB only"
  # VPCを指定
  # * ECSタスクが配置されるVPCを指定
  vpc_id      = var.vpc_id

  # 入力トラフィック
  # * ECSタスクに対して許可するインバウンドトラフィックを制御する
  ingress {
    from_port       = 80 # HTTP: ALBからのトラフィックを許可
    to_port         = var.container_port # コンテナポート
    protocol        = "tcp" # TCP
    security_groups = [var.alb_security_group_id] # ALBのセキュリティグループからのアクセスを許可
  }

  # 出力トラフィック
  # * ECSタスクから許可するアウトバウンドトラフィックを制御する
  egress {
    from_port   = 0 # すべてのポート
    to_port     = 0 # すべてのポート
    protocol    = "-1" # すべてのプロトコル
    cidr_blocks = ["0.0.0.0/0"] # すべてのIPアドレスへのアクセスを許可
  }

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-ecs-tasks-sg"
    Environment = var.environment
  }
}

# ECSサービスを作成
resource "aws_ecs_service" "main" {
  name            = "${var.project_name}-${var.environment}-service"
  # ECSクラスターを指定
  # * ECSサービスが配置されるクラスターを指定
  cluster         = var.ecs_cluster_id
  # タスク定義を指定
  # * ECSサービスが実行するタスク定義を指定
  task_definition = var.task_definition_arn
  # タスクの起動タイプを指定
  # * EC2: タスクをEC2インスタンスで実行
  # * FARGATE: タスクをFargateで実行
  launch_type     = "FARGATE"
  # タスク数を指定
  # * ECSサービスが実行するタスク数を指定
  desired_count   = var.desired_count

  # ネットワーク構成を指定
  network_configuration {
    # サブネットを指定
    # * ECSサービスが配置されるサブネットを指定
    subnets          = var.private_subnet_ids # プライベートサブネット
    # セキュリティグループを指定
    # * ECSサービスが配置されるセキュリティグループを指定
    security_groups  = [aws_security_group.ecs_tasks.id] # ECSタスクのセキュリティグループ
    # パブリックIPアドレスを自動割り当て
    assign_public_ip = false
  }

  # ロードバランサーを指定
  # * ECSサービスが登録されるロードバランサーを指定
  load_balancer {
    # ターゲットグループを指定
    # * ECSサービスが登録されるターゲットグループを指定
    target_group_arn = var.target_group_arn
    # コンテナ名を指定
    # * ECSサービスが登録されるコンテナ名を指定
    container_name   = "${var.project_name}-container"
    # コンテナポートを指定
    # * ECSサービスが登録されるコンテナポートを指定
    container_port   = var.container_port
  }

  # デプロイメント設定を指定
  deployment_minimum_healthy_percent = 50 # 最小のタスク数のパーセンテージ
  deployment_maximum_percent         = 200 # 最大のタスク数のパーセンテージ

  # ライフサイクルポリシーを指定
  lifecycle {
    # desired_countの変更を無視
    ignore_changes = [desired_count]
  }

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-service"
    Environment = var.environment
  }
}

# ECSサービスのスケーリングを作成
resource "aws_appautoscaling_target" "ecs_target" {
  # Min/Maxのタスク数を指定
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  # サービスのリソースIDを指定
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# スケーリングポリシーを作成
resource "aws_appautoscaling_policy" "scale_up" {
  name               = "${var.project_name}-${var.environment}-scale-up"
  # スケーリングポリシーの種類を指定
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  # スケーリングポリシーの設定を指定
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}
