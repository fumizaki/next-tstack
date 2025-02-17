output "alb_security_group_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "Security group ID of the ECS"
  value       = aws_security_group.ecs.id
}

output "vpce_security_group_id" {
  description = "Security group ID of the VPC Endpoint"
  value       = aws_security_group.vpce.id
  
}