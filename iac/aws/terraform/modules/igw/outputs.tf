output "igw_id" {
  description = "ID of the created Internet Gateway"
  value       = aws_internet_gateway.main.id 
}