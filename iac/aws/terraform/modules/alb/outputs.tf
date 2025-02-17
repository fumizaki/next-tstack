output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.webview.arn
}

output "http_listener_arn" {
  description = "ARN of the http listener"
  value       = aws_lb_listener.http.arn 
}
