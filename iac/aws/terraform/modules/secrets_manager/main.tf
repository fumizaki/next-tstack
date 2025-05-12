# Random password for PostgreSQL
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "nextjs-db-credentials"
  description = "Database credentials for Next.js application"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username      = var.rdb_username
    password      = random_password.db_password.result
    engine        = "postgres"
    host          = var.rdb_host
    port          = var.rdb_port
    dbname        = var.rdb_name
    dbInstanceArn = var.rdb_arn
  })
}


resource "aws_iam_policy" "secrets_manager_access" {
  name        = "nextjs-secrets-manager-access"
  description = "Allow access to the Secrets Manager for database credentials"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Effect   = "Allow"
        Resource = aws_secretsmanager_secret.db_credentials.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_manager_access" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.secrets_manager_access.arn
}