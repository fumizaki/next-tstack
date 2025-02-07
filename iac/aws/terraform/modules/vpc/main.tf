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