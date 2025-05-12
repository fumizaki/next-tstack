variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "username" {
  description = "The username for the RDS instance"
  type        = string
}

variable "password" {
  description = "The password for the RDS instance"
  type        = string
}

variable "rdb_subnet_group_name" {
  description = "The name of the RDB subnet group"
  type        = string
}

variable "rdb_security_group_id" {
  description = "The security group ID for RDB"
  type        = string
}