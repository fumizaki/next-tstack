variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
    description = "The environment name"
    type        = string
}

variable "vpc_id" {
    description = "The VPC ID"
    type        = string
}


variable "webview_port" {
    description = "The port for the webview"
    type        = number
}

variable "rdb_port" {
    description = "The port for the rdb"
    type        = number
}