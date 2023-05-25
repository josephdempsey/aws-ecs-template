variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"dev\""
  default     = "dev"
}

variable "region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
  default     = "eu-west-1"
}

variable "aws-access-key" {
  type = string
}

variable "aws-secret-key" {
  type = string
}

variable "application-secrets" {
  description = "A map of secrets that is passed into the application. Formatted like ENV_VAR = VALUE"
  type        = map
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
  default     = ["eu-west-1"]
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.100.120.0/24"
}

variable "private_subnets" {
  description = "a list of CIDRs for private subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.100.120.64/26", "10.100.120.192/26"]
}

variable "public_subnets" {
  description = "a list of CIDRs for public subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.100.120.0/26", "10.100.120.128/26"]
}

variable "service_desired_count" {
  description = "Number of tasks running in parallel"
  default     = 1
}

variable "container_port" {
  description = "The port where the Docker is exposed"
  default     = 8000
}

variable "container_api_port" {
  description = "The api port where the Docker is exposed"
  default     = 8080
}
variable "container_ui_port" {
  description = "The ui port where the Docker is exposed"
  default     = 8000
}
variable "container_cpu" {
  description = "The number of cpu units used by the task"

}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
}

variable "health_check_path" {
  description = "Http path for task health check"
  default     = "/health"
}

variable "tsl_certificate_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
}

variable "tags" {
  description = "List of tags"
  type = map(string)
}

variable "dockerhub_username" {
  type = string
}

variable "dockerhub_repository" {
  type = string
}

variable "domain" {
  description = "Domain name"
}