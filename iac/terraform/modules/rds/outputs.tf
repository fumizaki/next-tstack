output "rds_id" {
    value = aws_db_instance.rdb.id
}

output "rds_endpoint" {
    value = aws_db_instance.rdb.endpoint
}