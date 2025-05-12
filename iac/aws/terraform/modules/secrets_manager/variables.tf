variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
    description = "The environment name"
    type        = string
}

variable "rdb_username" {
  description = "The username for the RDS instance"
  type        = string
}

variable "rdb_host" {
  description = "The host for the RDS instance"
  type        = string
}

variable "rdb_port" {
  description = "The port for the RDS instance"
  type        = number
}

variable "rdb_name" {
  description = "The name for the RDS instance"
  type        = string
}

variable "rdb_arn" {
  description = "The arn for the RDS instance"
  type        = string
}