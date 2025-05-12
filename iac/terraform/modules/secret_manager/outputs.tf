output "rdb_password" {
  description = "The password for the RDS instance"
  value       = aws_secretsmanager_secret_version.rdb_credentials.secret_string.password
  
}