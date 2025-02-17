terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}


module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr = var.vpc_cidr
}


module "subnet" {
  source = "../../modules/subnet"

  project_name = var.project_name
  environment  = var.environment
  vpc_id = module.vpc.vpc_id
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
}

module "igw" {
  source = "../../modules/igw"

  project_name = var.project_name
  environment  = var.environment
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source = "../../modules/route_table"

  project_name = var.project_name
  environment  = var.environment
  vpc_id = module.vpc.vpc_id
  igw_id = module.igw.igw_id
  public_route_cidr = "0.0.0.0/0"
  public_subnet_ids = module.subnet.public_subnet_ids
  private_subnet_ids = module.subnet.private_subnet_ids
}

module "security_group" {
  source = "../../modules/security_group"

  project_name = var.project_name
  environment  = var.environment
  vpc_id = module.vpc.vpc_id
  webview_port = var.webview_port
  
}

module "alb" {
  source = "../../modules/alb"

  project_name = var.project_name
  environment  = var.environment
  vpc_id = module.vpc.vpc_id
  alb_security_group_id = module.security_group.alb_security_group_id
  public_subnet_ids = module.subnet.public_subnet_ids
  webview_port = var.webview_port
}

module "vpc_endpoint" {
  source = "../../modules/vpc_endpoint"

  project_name = var.project_name
  environment  = var.environment
  region = var.aws_region
  vpc_id = module.vpc.vpc_id
  vpce_security_group_id = module.security_group.vpce_security_group_id
  private_subnet_ids = module.subnet.private_subnet_ids
}

module "cloudwatch_log_group" {
  source = "../../modules/cloudwatch"

  project_name = var.project_name
  environment  = var.environment
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "ecs" {
  source = "../../modules/ecs"

  project_name = var.project_name
  environment = var.environment
  region = var.aws_region
  vpc_id = module.vpc.vpc_id
  cloudwatch_log_group_arn = module.cloudwatch_log_group.cloudwatch_log_group_arn
  ecr_repository_url = module.ecr.ecr_repository_url
  private_subnet_ids = module.subnet.private_subnet_ids
  ecs_security_group_id = module.security_group.ecs_security_group_id
  webview_port = var.webview_port
  alb_target_group_arn = module.alb.target_group_arn
  alb_listener_arns = [module.alb.http_listener_arn]
}



# # VPC設定
# resource "aws_vpc" "main" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   tags = {
#     Name = "next-app-vpc"
#   }
# }

# # パブリックサブネット (ALB用)
# resource "aws_subnet" "public_1" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "ap-northeast-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "next-app-public-1"
#   }
# }

# resource "aws_subnet" "public_2" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "ap-northeast-1c"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "next-app-public-2"
#   }
# }

# # プライベートサブネット (ECS用)
# resource "aws_subnet" "private_1" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.11.0/24"
#   availability_zone = "ap-northeast-1a"

#   tags = {
#     Name = "next-app-private-1"
#   }
# }

# resource "aws_subnet" "private_2" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.12.0/24"
#   availability_zone = "ap-northeast-1c"

#   tags = {
#     Name = "next-app-private-2"
#   }
# }

# # インターネットゲートウェイ
# resource "aws_internet_gateway" "main" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "next-app-igw"
#   }
# }

# # パブリックルートテーブル
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main.id
#   }

#   tags = {
#     Name = "next-app-public-rt"
#   }
# }

# # プライベートルートテーブル
# resource "aws_route_table" "private_1" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "next-app-private-rt-1"
#   }
# }

# resource "aws_route_table" "private_2" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "next-app-private-rt-2"
#   }
# }

# resource "aws_route_table_association" "public_1" {
#   subnet_id      = aws_subnet.public_1.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "public_2" {
#   subnet_id      = aws_subnet.public_2.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "private_1" {
#   subnet_id      = aws_subnet.private_1.id
#   route_table_id = aws_route_table.private_1.id
# }

# resource "aws_route_table_association" "private_2" {
#   subnet_id      = aws_subnet.private_2.id
#   route_table_id = aws_route_table.private_2.id
# }

# # セキュリティグループ
# resource "aws_security_group" "alb" {
#   name        = "next-app-alb-sg"
#   description = "ALB security group"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "next-app-alb-sg"
#   }
# }

# resource "aws_security_group" "ecs" {
#   name        = "next-app-ecs-sg"
#   description = "ECS security group"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port       = 3000
#     to_port         = 3000
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "next-app-ecs-sg"
#   }
# }

# # VPC Endpoints
# resource "aws_vpc_endpoint" "ecs" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.ap-northeast-1.ecs"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
#   security_group_ids  = [aws_security_group.vpce.id]
#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "ecs_agent" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.ap-northeast-1.ecs-agent"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
#   security_group_ids  = [aws_security_group.vpce.id]
#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "ecs_telemetry" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.ap-northeast-1.ecs-telemetry"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
#   security_group_ids  = [aws_security_group.vpce.id]
#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.ap-northeast-1.ecr.dkr"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
#   security_group_ids  = [aws_security_group.vpce.id]
#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.ap-northeast-1.ecr.api"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
#   security_group_ids  = [aws_security_group.vpce.id]
#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "logs" {
#   vpc_id              = aws_vpc.main.id
#   service_name        = "com.amazonaws.ap-northeast-1.logs"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
#   security_group_ids  = [aws_security_group.vpce.id]
#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.ap-northeast-1.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids   = [aws_route_table.private_1.id, aws_route_table.private_2.id]
# }

# # VPCエンドポイント用のセキュリティグループ
# resource "aws_security_group" "vpce" {
#   name        = "next-app-vpce-sg"
#   description = "Security group for VPC endpoints"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port       = 443
#     to_port         = 443
#     protocol        = "tcp"
#     security_groups = [aws_security_group.ecs.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "next-app-vpce-sg"
#   }
# }



# # ECR リポジトリ
# resource "aws_ecr_repository" "app" {
#   name = "next-app"
#   force_delete = true

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }

# # ECS クラスター
# resource "aws_ecs_cluster" "main" {
#   name = "next-app-cluster"

#   setting {
#     name  = "containerInsights"
#     value = "enabled"
#   }
# }

# # ECS タスク実行ロール
# resource "aws_iam_role" "ecs_task_execution_role" {
#   name = "next-app-task-execution-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # ECSタスク実行ロールのポリシーアタッチメント
# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# # CloudWatch Logsへのアクセス権限
# resource "aws_iam_role_policy" "ecs_task_execution_cloudwatch" {
#   name = "next-app-task-execution-cloudwatch"
#   role = aws_iam_role.ecs_task_execution_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ]
#         Resource = "${aws_cloudwatch_log_group.app.arn}:*"
#       }
#     ]
#   })
# }

# # ECRへのアクセス権限
# resource "aws_iam_role_policy" "ecs_task_execution_ecr" {
#   name = "next-app-task-execution-ecr"
#   role = aws_iam_role.ecs_task_execution_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "ecr:GetAuthorizationToken",
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# # ECSタスクロール（コンテナ実行時のロール）
# resource "aws_iam_role" "ecs_task_role" {
#   name = "next-app-task-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # タスク定義（更新）
# resource "aws_ecs_task_definition" "app" {
#   family                   = "next-app"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "256"
#   memory                   = "512"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn           = aws_iam_role.ecs_task_role.arn  # タスクロールを追加

#   container_definitions = jsonencode([
#     {
#       name  = "next-app"
#       image = "${aws_ecr_repository.app.repository_url}:latest"
#       portMappings = [
#         {
#           containerPort = 3000
#           protocol      = "tcp"
#         }
#       ]
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           "awslogs-group"         = "/ecs/next-app"
#           "awslogs-region"        = "ap-northeast-1"
#           "awslogs-stream-prefix" = "ecs"
#         }
#       }
#       environment = [
#         {
#           name  = "PORT"
#           value = "3000"
#         }
#       ]
#     }
#   ])
# }

# # CloudWatch Logs グループ
# resource "aws_cloudwatch_log_group" "app" {
#   name              = "/ecs/next-app"
#   retention_in_days = 30
# }


# # ALB
# resource "aws_lb" "main" {
#   name               = "next-app-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb.id]
#   subnets           = [aws_subnet.public_1.id, aws_subnet.public_2.id]

#   enable_deletion_protection = true

#   tags = {
#     Name = "next-app-alb"
#   }
# }

# resource "aws_lb_target_group" "app" {
#   name        = "next-app-tg"
#   port        = 3000
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.main.id
#   target_type = "ip"

#   health_check {
#     enabled             = true
#     healthy_threshold   = 2
#     interval            = 30
#     matcher            = "200"
#     path               = "/"
#     timeout            = 5
#     unhealthy_threshold = 2
#   }
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app.arn
#   }
# }

# # ECS サービス
# resource "aws_ecs_service" "app" {
#   name            = "next-app"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.app.arn
#   desired_count   = 2
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets         = [aws_subnet.private_1.id, aws_subnet.private_2.id]
#     security_groups = [aws_security_group.ecs.id]
#     assign_public_ip = false
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.app.arn
#     container_name   = "next-app"
#     container_port   = 3000
#   }

#   depends_on = [aws_lb_listener.http]
# }

# # 出力
# output "ecr_repository_url" {
#   value = aws_ecr_repository.app.repository_url
# }

# output "alb_dns_name" {
#   value = aws_lb.main.dns_name
# }
