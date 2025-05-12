output "alb_security_group_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.alb.id
}

output "webview_security_group_id" {
  description = "Security group ID of the Webview"
  value       = aws_security_group.webview.id
}

output "rdb_security_group_id" {
  description = "Security group ID of the RDB"
  value       = aws_security_group.rdb.id
}

output "vpce_security_group_id" {
  description = "Security group ID of the VPC Endpoint"
  value       = aws_security_group.vpce.id
  
}