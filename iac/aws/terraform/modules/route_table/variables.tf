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

variable "private_subnet_ids" {
    description = "The private subnet IDs"
    type        = list(string)
}
