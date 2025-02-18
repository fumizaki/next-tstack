variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
    description = "The environment name"
    type        = string
}

variable "region" {
    description = "The region"
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

variable "private_subnet_ids" {
    description = "The private subnet IDs"
    type        = list(string)
}

variable "private_route_table_ids" {
    description = "The private route table IDs"
    type        = list(string)
  
}