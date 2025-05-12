variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
    description = "The AWS region"
    type        = string
}

variable "vpc_id" {
    description = "The VPC ID"
    type        = string
}


variable "vpce_security_group_id" {
    description = "The security group ID for the VPC Endpoint"
    type        = string
}

variable "webview_subnet_ids" {
    description = "The Webview subnet IDs"
    type        = list(string)
}

variable "webview_route_table_ids" {
    description = "The Webview route table IDs"
    type        = list(string)
  
}