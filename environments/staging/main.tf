

module "vpc" {
  source             = "../../modules/vpc"
  name               = "${var.name}-${var.environment}"
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
  tags               = var.tags
}

module "alb" {
  source              = "../../modules/alb"
  name                = "${var.name}-${var.environment}"
  vpc_id              = module.vpc.vpc_id
  container_port      = 80
  public_subnets      = module.vpc.public_subnets
  environment         = var.environment
  alb_tls_cert_arn    = var.tsl_certificate_arn
  health_check_path   = var.health_check_path
  tags                = var.tags
  domain              = var.domain

  depends_on = [
    module.vpc
  ]
}

module "secrets" {
  source              = "../../modules/secrets"
  name                = "${var.name}-${var.environment}"
  environment         = var.environment
  application-secrets = var.application-secrets
}

module "ecs" {
  source                      = "../../modules/ecs"
  name                        = "${var.name}-${var.environment}"
  environment                 = var.environment
  region                      = var.region
  private_subnets             = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  dockerhub_username          = var.dockerhub_username
  dockerhub_repository        = var.dockerhub_repository
  dockerhub_secret            = "${var.name}-${var.environment}-application-secrets-DockerHubCredentials"
  service_desired_count       = var.service_desired_count
  lb_security_group_id        = module.alb.lb_security_group_id
  vpc_id                      = module.vpc.vpc_id
  container_environment = [
    { name = "LOG_LEVEL",
    value = "DEBUG" },
    { name = "PORT",
    value = var.container_port }
  ]
  container_secrets      = module.secrets.secrets_map
  container_secrets_arns = module.secrets.application_secrets_arn
  tags                = var.tags

  depends_on = [
    module.secrets
  ]
}