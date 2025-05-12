variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
    description = "The VPC ID"
    type        = string
}

variable "alb_security_group_id" {
    description = "The security group ID of the ALB"
    type        = string
}

variable "public_subnet_ids" {
    description = "The public subnet IDs"
    type        = list(string)
}

variable "webview_port" {
    description = "The port for the webview"
    type        = number
}