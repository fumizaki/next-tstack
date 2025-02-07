# インターネットゲートウェイを作成
# * インターネットゲートウェイ: VPC内のリソースがインターネットに接続できるようにするためのゲートウェイ
resource "aws_internet_gateway" "main" {
  # VPCを指定
  # * インターネットゲートウェイをアタッチするVPCを指定
  # ** インターネットゲートウェイによってVPC内のリソースがインターネットに接続できるようになる
  vpc_id = var.vpc_id

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
  }
}
