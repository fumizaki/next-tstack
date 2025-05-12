variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
    description = "The environment name"
    type        = string
}

variable "rdb_subnet_group_name" {
    description = "The name of the RDS subnet group"
    type        = string
}

variable "rds_security_group_id" {
    description = "The security group ID for RDS"
    type        = string
}