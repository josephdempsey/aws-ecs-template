variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "private_subnets" {
  description = "Comma separated list of subnet IDs"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "aws_alb_target_group_arn" {
  description = "ARN of the alb target group"
}

variable "container_port" {
  description = "The port where the Docker is exposed"
}
variable "container_cpu" {
  description = "The number of cpu units used by the task"
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
}

variable "dockerhub_username" {
  description = "dockerhub username"
}

variable "dockerhub_repository" {
  description = "dockerhub repository"
}

variable "dockerhub_secret" {
  description = "dockerhub secret"
}

variable "service_desired_count" {
  description = "service_desired_count"
}

variable "lb_security_group_id" {
  description = "lb_security_group_id"
}

variable "container_environment" {
  description = "container_environment"
}

variable "container_secrets" {
  description = "container_secrets"
}

variable "container_secrets_arns" {
  description = "container_secrets_arns"
}

variable "tags" {
  description = "List of tags"
  type = map(string)
}
