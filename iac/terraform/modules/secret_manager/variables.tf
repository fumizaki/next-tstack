variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "webview_task_execution_role_name" {
  description = "The name of the webview task execution role"
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