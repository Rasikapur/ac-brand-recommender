output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.service_name
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "app_url" {
  description = "Application URL"
  value       = "http://${module.alb.alb_dns_name}"
}

output "ecr_login_command" {
  description = "Command to login to ECR"
  value       = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}

output "docker_build_push" {
  description = "Commands to build and push Docker image"
  value       = <<-EOT
    docker build -t ${module.ecr.repository_url}:latest .
    docker push ${module.ecr.repository_url}:latest
  EOT
}

output "ecs_force_deploy" {
  description = "Command to force new ECS deployment"
  value       = "aws ecs update-service --cluster ${module.ecs.cluster_name} --service ${module.ecs.service_name} --force-new-deployment --region ${var.aws_region}"
}
