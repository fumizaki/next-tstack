variable "project_name" {
  description = "Project name used for tagging and naming resources"
  type        = string
  default     = "nextjs-app"
}

variable "environment" {
  description = "Environment name (e.g., dev, stg, prd)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_webview_subnet_cidrs" {
  description = "List of CIDR blocks for private webview subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_rdb_subnet_cidrs" {
  description = "List of CIDR blocks for private rdb subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones for the subnets"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"] # 東京リージョンの例
}

variable "ecr_repository_name" {
  description = "Name for the ECR repository"
  type        = string
  default     = "nextjs-app-repo"
}

variable "ecs_cluster_name" {
  description = "Name for the ECS cluster"
  type        = string
  default     = "nextjs-app-cluster"
}

variable "ecs_service_name" {
  description = "Name for the ECS service"
  type        = string
  default     = "nextjs-app-service"
}

variable "ecs_task_cpu" {
  description = "CPU units for the ECS task"
  type        = number
  default     = 256 # 0.25 vCPU
}

variable "ecs_task_memory" {
  description = "Memory (MiB) for the ECS task"
  type        = number
  default     = 512 # 0.5 GB
}

variable "ecs_task_desired_count" {
  description = "Desired number of tasks for the ECS service"
  type        = number
  default     = 1
}

variable "app_port" {
  description = "Port the application container listens on"
  type        = number
  default     = 3000
}

variable "db_name" {
  description = "Name for the RDS database"
  type        = string
  default     = "nextjsdb"
}

variable "db_username" {
  description = "Username for the RDS database master user"
  type        = string
  default     = "adminuser"
}

variable "db_instance_class" {
  description = "Instance class for the RDS database"
  type        = string
  default     = "db.t3.micro" # 開発用。必要に応じて変更
}

variable "db_allocated_storage" {
  description = "Allocated storage for the RDS database (in GB)"
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "PostgreSQL engine version for RDS"
  type        = string
  default     = "15.6" # 最新の安定版などを指定
}