# VPCを作成
# * VPC: AWSの仮想プライベートクラウド
resource "aws_vpc" "main" {
  # VPCのCIDRブロックを指定
  # * CIDRブロックはVPC内の有効なIPアドレス範囲を表す
  cidr_block           = var.vpc_cidr
  # DNSホスト名を有効化
  # * true: インスタンスにパブリックDNSホスト名を割り当てる
  # ** インスタンスにパブリックDNSホスト名を割り当てる場合、インスタンスはAmazonProvidedDNSサーバーを使用してDNS解決を行う
  # *** AmazonProvidedDNSサーバーはAmazonが提供するDNSサーバー
  # * false: インスタンスにパブリックDNSホスト名を割り当てない
  enable_dns_hostnames = true
  # DNSサポートを有効化
  # * true: インスタンスにDNSサポートを有効化
  # ** DNSサポートを有効化にする場合、インスタンスはAmazonProvidedDNSサーバーを使用してDNS解決を行う
  # *** AmazonProvidedDNSサーバーはAmazonが提供するDNSサーバー
  # * false: インスタンスにDNSサポートを有効化しない
  enable_dns_support   = true

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
  }
}

# インターネットゲートウェイを作成
# * インターネットゲートウェイ: VPC内のリソースがインターネットに接続できるようにするためのゲートウェイ
resource "aws_internet_gateway" "main" {
  # VPCを指定
  # * インターネットゲートウェイをアタッチするVPCを指定
  # ** インターネットゲートウェイによってVPC内のリソースがインターネットに接続できるようになる
  vpc_id = aws_vpc.main.id

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
  }
}

# パブリックサブネットを作成
# * パブリックサブネット: インターネットゲートウェイに接続されたサブネット
resource "aws_subnet" "public" {
  # カウントを指定
  # * サブネットを複数作成する場合、カウントを指定して複数のサブネットを作成
  count                   = length(var.public_subnet_cidrs)
  # VPCを指定
  # * サブネットが配置されるVPCを指定
  vpc_id                  = aws_vpc.main.id
  # パブリックサブネットのCIDRブロックを指定
  # * CIDRブロックはサブネット内のIPアドレス範囲を表す
  cidr_block              = var.public_subnet_cidrs[count.index]
  # アベイラビリティゾーンを指定
  # * サブネットが配置されるアベイラビリティゾーンを指定
  # ** アベイラビリティゾーンはAWSのデータセンターが配置されている地域
  availability_zone       = data.aws_availability_zones.available.names[count.index]
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
  vpc_id            = aws_vpc.main.id
  # プライベートサブネットのCIDRブロックを指定
  # * CIDRブロックはサブネット内のIPアドレス範囲を表す
  cidr_block        = var.private_subnet_cidrs[count.index]
  # アベイラビリティゾーンを指定
  # * サブネットが配置されるアベイラビリティゾーンを指定
  # ** アベイラビリティゾーンはAWSのデータセンターが配置されている地域
  availability_zone = data.aws_availability_zones.available.names[count.index]

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# ルートテーブルを作成
# * ルートテーブル: サブネット内のトラフィックをルーティングするためのルールを保持するテーブル
resource "aws_route_table" "public" {
  # VPCを指定
  # * ルートテーブルが関連付けられるVPCを指定
  vpc_id = aws_vpc.main.id

  # ルートを追加
  # * CIDRブロックに対してインターネットゲートウェイにルーティングするルートを追加
  route {
    cidr_block = "0.0.0.0/0" # すべてのIPアドレス
    gateway_id = aws_internet_gateway.main.id # インターネットゲートウェイ
  }

  # タグを指定
  tags = {
    Name        = "${var.project_name}-${var.environment}-public-rt"
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

# アベイラビリティゾーンを取得
data "aws_availability_zones" "available" {
  # カスタムフィルタを指定
  # * カスタムフィルタを使用してアベイラビリティゾーンをフィルタリング
  state = "available" # 利用可能なアベイラビリティゾーン
}