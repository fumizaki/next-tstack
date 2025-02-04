output "task_definition_arn" {
  description = "The ARN of the ECS task definition"
  value       = aws_ecs_task_definition.main.arn
}

output "task_definition_family" {
  description = "The family of the task definition"
  value       = aws_ecs_task_definition.main.family
}

output "execution_role_arn" {
  description = "The ARN of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}