resource "aws_cloudwatch_log_group" "webview" {
  name              = "/ecs/webview/${var.environment}-${var.project_name}"
  retention_in_days = 30
}