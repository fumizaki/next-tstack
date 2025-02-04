terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "../../modules/networking"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "alb" {
  source = "../../modules/alb"

  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.networking.vpc_id
  public_subnet_ids   = module.networking.public_subnet_ids
  container_port      = 3000
  health_check_path   = "/"
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "ecs_cluster" {
  source = "../../modules/ecs_cluster"

  project_name = var.project_name
  environment  = var.environment
}

module "task_definition" {
  source = "../../modules/ecs_task_definition"

  project_name         = var.project_name
  environment          = var.environment
  ecr_repository_url   = module.ecr.repository_url
  container_image_tag  = "latest"  # または特定のタグを指定
  task_cpu            = var.ecs_task_cpu
  task_memory         = var.ecs_task_memory
  container_port      = 3000
  aws_region          = var.aws_region
  log_group_name      = module.ecs_cluster.log_group_name

  environment_variables = [
    {
      name  = "NODE_ENV"
      value = var.environment
    }
    # 必要に応じて環境変数を追加
  ]
}

module "ecs_service" {
  source = "../../modules/ecs_service"

  project_name            = var.project_name
  environment             = var.environment
  ecs_cluster_id          = module.ecs_cluster.cluster_id
  ecs_cluster_name        = module.ecs_cluster.cluster_name
  task_definition_arn     = module.task_definition.task_definition_arn
  vpc_id                  = module.networking.vpc_id
  private_subnet_ids      = module.networking.private_subnet_ids
  target_group_arn        = module.alb.target_group_arn
  alb_security_group_id   = module.alb.alb_security_group_id
  container_port          = 3000
  desired_count           = 2
  min_capacity            = 1
  max_capacity            = 4
}

