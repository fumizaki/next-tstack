variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
    description = "The environment name"
    type        = string
}


variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type        = string
}
