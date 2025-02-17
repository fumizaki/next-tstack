variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
    description = "The environment name"
    type        = string
}

variable "region" {
    description = "The AWS region"
    type        = string
}

variable "vpc_id" {
    description = "The VPC ID"
    type        = string
}

variable "cloudwatch_log_group_arn" {
    description = "The ARN of the CloudWatch log group"
    type        = string
}

variable "ecr_repository_url" {
    description = "The URL of the ECR repository"
    type        = string
}

variable "private_subnet_ids" {
    description = "The private subnet IDs"
    type        = list(string)
  
}

variable "ecs_security_group_id" {
    description = "The security group ID for the ECS"
    type        = string
  
}

variable "webview_port" {
    description = "The port for the webview"
    type        = number
}

variable "alb_target_group_arn" {
    description = "The ARN of the ALB target group"
    type        = string
}

variable "alb_listener_arns" {
    description = "The ARNs of the ALB listeners"
    type        = list(string)
}