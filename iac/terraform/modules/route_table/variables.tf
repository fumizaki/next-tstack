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

variable "igw_id" {
    description = "The Internet Gateway ID"
    type        = string
  
}

variable "public_route_cidr" {
    description = "The CIDR block for the public route"
    type        = string
}

variable "public_subnet_ids" {
    description = "The public subnet IDs"
    type        = list(string)
}

variable "webview_subnet_ids" {
    description = "The Webview subnet IDs"
    type        = list(string)
}

variable "rdb_subnet_ids" {
    description = "The RDB subnet IDs"
    type        = list(string)
}