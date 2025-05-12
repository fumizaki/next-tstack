# resource "aws_db_subnet_group" "db" {
#   name       = "nextjs-db-subnet-group"
#   subnet_ids = [aws_subnet.private_db_1.id, aws_subnet.private_db_2.id]

#   tags = {
#     Name = "nextjs-db-subnet-group"
#   }
# }

resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "14.7"
  instance_class         = "db.t3.micro"
  db_name                = "${var.project_name}_${var.environment}"
  username               = "dbadmin"
  password               = "dbpassword123"
  parameter_group_name   = "default.postgres14"
  db_subnet_group_name   = var.rdb_subnet_group_name
  vpc_security_group_ids = [var.rds_security_group_id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = true

  tags = {
    Name = "${var.project_name}-${var.environment}-rds"
  }
}