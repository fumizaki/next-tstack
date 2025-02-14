output "vpce_security_group_id" {
  description = "Security group ID of the VPC endpoint"
  value       = aws_security_group.vpc_endpoint.id
}