# S3リモートステートを利用するための設定ファイル

# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "webview/dev/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }