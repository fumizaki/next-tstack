# パブリックサブネットを作成
# * パブリックサブネット: インターネットゲートウェイに接続されたサブネット
resource "aws_subnet" "public" {
  # カウントを指定
  # * サブネットを複数作成する場合、カウントを指定して複数のサブネットを作成
  count                   = length(var.public_subnet_cidrs)
  # VPCを指定
  # * サブネットが配置されるVPCを指定
  vpc_id                  = var.vpc_id
  # パブリックサブネットのCIDRブロックを指定
  # * CIDRブロックはサブネット内のIPアドレス範囲を表す
  cidr_block              = var.public_subnet_cidrs[count.index]
  # アベイラビリティゾーンを指定
  # * サブネットが配置されるアベイラビリティゾーンを指定
  # ** アベイラビリティゾーンはAWSのデータセンターが配置されている地域
  availability_zone       = var.availability_zones[count.index]
  # パブリックIPアドレスを自動割り当て
  # * true: インスタンスにパブリックIPアドレスを自動割り当て
  # ** インスタンスにパブリックIPアドレスを自動割り当てる場合、インスタンスはインターネットに接続できる
  # * false: インスタンスにパブリックIPアドレスを自動割り当てない
  map_public_ip_on_launch = true

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# プライベートサブネットを作成
# * プライベートサブネット: インターネットゲートウェイに接続されていないサブネット
resource "aws_subnet" "private" {
  # カウントを指定
  # * サブネットを複数作成する場合、カウントを指定して複数のサブネットを作成
  count             = length(var.private_subnet_cidrs)
  # VPCを指定
  # * サブネットが配置されるVPCを指定
  vpc_id            = var.vpc_id
  # プライベートサブネットのCIDRブロックを指定
  # * CIDRブロックはサブネット内のIPアドレス範囲を表す
  cidr_block        = var.private_subnet_cidrs[count.index]
  # アベイラビリティゾーンを指定
  # * サブネットが配置されるアベイラビリティゾーンを指定
  # ** アベイラビリティゾーンはAWSのデータセンターが配置されている地域
  availability_zone = var.availability_zones[count.index]

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# ルートテーブルを作成
# * ルートテーブル: サブネット内のトラフィックをルーティングするためのルールを保持するテーブル
resource "aws_route_table" "public" {
  # カウントを指定
  # * ルートテーブルを複数作成する場合、カウントを指定して複数のルートテーブルを作成
  count  = length(var.public_subnet_cidrs)
  # VPCを指定
  # * ルートテーブルが関連付けられるVPCを指定
  vpc_id = var.vpc_id

  # ルートを追加
  # * CIDRブロックに対してインターネットゲートウェイにルーティングするルートを追加
  route {
    cidr_block = "0.0.0.0/0" # すべてのIPアドレス
    gateway_id = var.igw_id # インターネットゲートウェイ
  }

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-public-${count.index + 1}"
    Environment = var.environment
  }
}

# ルートテーブルを作成
# * ルートテーブル: サブネット内のトラフィックをルーティングするためのルールを保持するテーブル
resource "aws_route_table" "private" {
  # カウントを指定
  # * ルートテーブルを複数作成する場合、カウントを指定して複数のルートテーブルを作成
  count  = length(var.private_subnet_cidrs)
  # VPCを指定
  # * ルートテーブルが関連付けられるVPCを指定
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-${count.index + 1}"
    Environment = var.environment
  }
}

# パブリックサブネットにルートテーブルを関連付け
resource "aws_route_table_association" "public" {
  # カウントを指定
  # * ルートテーブルを複数のサブネットに関連付ける場合、カウントを指定して複数のルートテーブルを関連付け
  count          = length(var.public_subnet_cidrs)
  # サブネットIDを指定
  # * ルートテーブルを関連付けるサブネットのIDを指定
  subnet_id      = aws_subnet.public[count.index].id
  # ルートテーブルIDを指定
  # * 関連付けるルートテーブルのIDを指定
  route_table_id = aws_route_table.public.id
}




# プライベートサブネットにルートテーブルを関連付け
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
