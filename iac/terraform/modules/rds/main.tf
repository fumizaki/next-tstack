resource "aws_db_instance" "rdb" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "14.7"
  instance_class         = "db.t3.micro"
  db_name                = "${var.environment}_${var.project_name}"
  username               = "${var.username}"
  password               = "${var.password}"
  parameter_group_name   = "default.postgres14"
  db_subnet_group_name   = var.rdb_subnet_group_name
  vpc_security_group_ids = [var.rdb_security_group_id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = true

  tags = {
    Name = "${var.environment}-${var.project_name}-rds"
  }
}