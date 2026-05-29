variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "ac-brand-recommender"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ecr_image_retention_count" {
  description = "Number of images to retain in ECR"
  type        = number
  default     = 10
}

variable "container_image_tag" {
  description = "Tag of the container image to deploy"
  type        = string
  default     = "latest"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 5000
}

variable "ecs_task_cpu" {
  description = "CPU units for the ECS task (1024 = 1 vCPU)"
  type        = number
  default     = 512
}

variable "ecs_task_memory" {
  description = "Memory for the ECS task in MB"
  type        = number
  default     = 1024
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "cloudwatch_log_retention_days" {
  description = "Days to retain CloudWatch logs"
  type        = number
  default     = 30
}
