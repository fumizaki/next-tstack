# VPCエンドポイントのセキュリティグループ
resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.project_name}-${var.environment}-vpce-sg"
  description = "VPCエンドポイント用のセキュリティグループ"
  vpc_id      = var.vpc_id

  # ECSタスクからVPCエンドポイントへアクセス許可
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs  # プライベートサブネットからのみ許可
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpce-sg"
    Environment = var.environment
  }
}


# ECR API 用 VPCエンドポイント
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_endpoint.id]

  tags = {
    Name        = "${var.project_name}-${var.environment}-ecr-api-vpce"
    Environment = var.environment
  }
}


# ECR Docker 用 VPCエンドポイント
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            =var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_endpoint.id]

  tags = {
    Name        = "${var.project_name}-${var.environment}-ecr-dkr-vpce"
    Environment = var.environment
  }
}

