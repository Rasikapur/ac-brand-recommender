terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "networking" {
  source = "../modules/networking"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

module "ecr" {
  source = "../modules/ecr"

  project_name          = var.project_name
  environment           = var.environment
  image_retention_count = var.ecr_image_retention_count
}

module "iam" {
  source = "../modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "alb" {
  source = "../modules/alb"

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.networking.vpc_id
  subnet_ids      = module.networking.public_subnet_ids
  container_port  = var.container_port
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project_name}-${var.environment}-ecs-sg"
  description = "Security group for ECS Fargate tasks"
  vpc_id      = module.networking.vpc_id

  ingress {
    description     = "From ALB"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [module.alb.alb_security_group_id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-sg"
  }
}

module "ecs" {
  source = "../modules/ecs"

  project_name       = var.project_name
  environment        = var.environment
  container_image    = "${module.ecr.repository_url}:${var.container_image_tag}"
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
  subnet_ids         = module.networking.public_subnet_ids
  security_group_id  = aws_security_group.ecs_tasks.id
  task_cpu           = var.ecs_task_cpu
  task_memory        = var.ecs_task_memory
  desired_count      = var.ecs_desired_count
  log_retention_days = var.cloudwatch_log_retention_days
  container_port     = var.container_port
  target_group_arn   = module.alb.target_group_arn

  depends_on = [module.ecr, module.iam, module.networking, module.alb]
}
