variable "environment" {
    description = "The environment name"
    type        = string
    default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "next-tstack"
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "ecs_task_cpu" {
  description = "CPU units for ECS task"
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "Memory for ECS task (in MiB)"
  type        = number
  default     = 512
}

variable "webview_ecs_cluster" {
    description = "The ECS cluster name for the webview"
    type        = string
    default     = "webview-cluster"
}

variable "webview_ecs_service" {
    description = "The ECS service name for the webview"
    type        = string
    default     = "webview-service"
}

variable "webview_container_port" {
    description = "The container port for the webview"
    type        = number
    default     = 3000
}

variable "webview_desired_count" {
    description = "The desired count for the webview"
    type        = number
    default     = 2
}
