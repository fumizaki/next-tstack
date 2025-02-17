output "cloudwatch_log_group_arn" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.app.arn  
}