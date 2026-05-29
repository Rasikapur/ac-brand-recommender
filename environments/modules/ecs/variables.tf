variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "container_image" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "task_cpu" {
  type    = string
  default = "512"
}

variable "task_memory" {
  type    = string
  default = "1024"
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "container_port" {
  type    = number
  default = 5000
}
