output "subnet_ids" {
  description = "List of IDs of the created subnets"
  value       = aws_subnet.main[*].id
}

output "subnet_cidrs" {
  description = "List of CIDR blocks of the created subnets"
  value       = aws_subnet.main[*].cidr_block
}

output "subnet_arns" {
  description = "List of ARNs of the created subnets"
  value       = aws_subnet.main[*].arn
}