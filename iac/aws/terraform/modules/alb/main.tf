# セキュリティグループを作成
# * セキュリティグループ: インスタンスに許可するトラフィックを制御するためのリソース
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for ALB"
  # VPCを指定
  # * ALBが配置されるVPCを指定
  vpc_id      = var.vpc_id

  # 入力トラフィック
  # * ALBに対して許可するインバウンドトラフィックを制御する
  ingress {
    from_port   = 80 # HTTP
    to_port     = 80 # HTTP
    protocol    = "tcp" # TCP
    cidr_blocks = ["0.0.0.0/0"] # 全てのIPアドレスからのアクセスを許可
  }

  # 出力トラフィック
  # * ALBから許可するアウトバウンドトラフィックを制御する
  egress {
    from_port   = 0 # すべてのポート
    to_port     = 0 # すべてのポート
    protocol    = "-1" # すべてのプロトコル
    cidr_blocks = ["0.0.0.0/0"] # すべてのIPアドレスへのアクセスを許可
  }

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-alb-sg"
    Environment = var.environment
  }
}

# ロードバランサーを作成
# * ロードバランサー: トラフィックを複数のターゲットに分散するためのリソース
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  # application: L7ロードバランサー(ALB)
  # * application: HTTP/HTTPSのリクエストを処理するLB
  # network: L4ロードバランサー(NLB)
  # * network: TCP/UDPのリクエストを処理するLB
  load_balancer_type = "application"
  # internal: true で内部ALBになる
  # * 内部ALBはVPC内のリソースからのみアクセス可能なALB
  # internal: false でインターネットに公開されるALBになる
  internal           = false
  # セキュリティグループを指定
  # * ALBに対して許可するインバウンドトラフィックを制御する
  security_groups    = [aws_security_group.alb.id]
  # サブネットを指定
  # * ALBが配置されるサブネットを指定
  subnets            = var.public_subnet_ids

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-alb"
    Environment = var.environment
  }
}

# ターゲットグループを作成
# * ターゲットグループ: ロードバランサーがリクエストを送信するターゲットのグループ
resource "aws_lb_target_group" "main" {
  name        = "${var.project_name}-${var.environment}-tg"
  # ターゲットグループのプロトコルを指定
  # * ターゲットグループがリクエストを送信するプロトコル
  protocol    = "HTTP"
  # ターゲットグループのポートを指定
  # * ターゲットグループに登録されたターゲットが受け付けるポート
  port        = var.container_port
  # VPCを指定
  # * ターゲットグループが配置されるVPCを指定
  vpc_id      = var.vpc_id
  # ターゲットタイプを指定
  # * ターゲットグループに登録されるターゲットのタイプを指定
  target_type = "ip"

  # ヘルスチェックを指定
  # * ターゲットグループがターゲットのヘルスチェックを行う方法を指定
  health_check {
    healthy_threshold   = 3 # 連続して成功するヘルスチェックの回数
    unhealthy_threshold = 3 # 連続して失敗するヘルスチェックの回数
    timeout             = 5 # ターゲットが応答を返すまでのタイムアウト時間
    path                = var.health_check_path # ヘルスチェックを行うパス
    interval            = 30 # ヘルスチェックの間隔
    matcher             = "200-399" # ヘルスチェックの成功を判断するステータスコード
  }

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-tg"
    Environment = var.environment
  }
}

# リスナーを作成
# * リスナー: ロードバランサーが受け付けるリクエストを処理するリソース
resource "aws_lb_listener" "http" {
  # ロードバランサーのARNを指定
  load_balancer_arn = aws_lb.main.arn
  # リスナーのポートを指定
  # * リスナーが受け付けるポート
  port              = 80
  # リスナーのプロトコルを指定
  # * リスナーが受け付けるリクエストのプロトコル
  protocol          = "HTTP"

  # デフォルトアクションを指定
  default_action {
    type             = "forward" # リクエストを転送する
    target_group_arn = aws_lb_target_group.main.arn # 転送先となるターゲットグループのARNを指定
  }
}