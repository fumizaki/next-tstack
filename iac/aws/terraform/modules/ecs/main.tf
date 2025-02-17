# ECS クラスター
resource "aws_ecs_cluster" "webview" {
  name = "${var.project_name}-${var.environment}-webview-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ECS タスク実行ロール
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-${var.environment}-webview-task-execution-role"

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

# ECSタスク実行ロールのポリシーアタッチメント
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch Logsへのアクセス権限
resource "aws_iam_role_policy" "ecs_task_execution_cloudwatch" {
  name = "${var.project_name}-${var.environment}-webview-task-execution-cloudwatch"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${var.cloudwatch_log_group_arn}:*"
      }
    ]
  })
}

# ECRへのアクセス権限
resource "aws_iam_role_policy" "ecs_task_execution_ecr" {
  name = "${var.project_name}-${var.environment}-webview-task-execution-ecr"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

# ECSタスクロール（コンテナ実行時のロール）
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project_name}-${var.environment}-webview-task-role"

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

# タスク定義（更新）
resource "aws_ecs_task_definition" "webview" {
  family                   = "${var.project_name}-${var.environment}-webview"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn           = aws_iam_role.ecs_task_role.arn  # タスクロールを追加

  container_definitions = jsonencode([
    {
      name  = "webview"
      image = "${var.ecr_repository_url}:latest"
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}-${var.environment}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [
        {
          name  = "PORT"
          value = "${var.webview_port}"
        }
      ]
    }
  ])
}


# ECS サービス
resource "aws_ecs_service" "webview" {
  name            = "${var.project_name}-${var.environment}-webview"
  cluster         = aws_ecs_cluster.webview.id
  task_definition = aws_ecs_task_definition.webview.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "${var.project_name}-${var.environment}-webview"
    container_port   = var.webview_port
  }

  depends_on = [var.alb_listener_arns]
}