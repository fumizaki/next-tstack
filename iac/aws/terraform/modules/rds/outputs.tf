output "rds_id" {
    value = aws_db_instance.postgres.id
}

output "rds_endpoint" {
    value = aws_db_instance.postgres.endpoint
}