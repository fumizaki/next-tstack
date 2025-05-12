variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
    description = "The VPC ID"
    type        = string
}

variable "webview_cloudwatch_log_group_arn" {
    description = "The ARN of the CloudWatch log group"
    type        = string
}

variable "webview_ecr_repository_url" {
    description = "The URL of the ECR repository"
    type        = string
}

variable "webview_subnet_ids" {
    description = "The private subnet IDs"
    type        = list(string)
  
}

variable "webview_security_group_id" {
    description = "The security group ID for the Webview"
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