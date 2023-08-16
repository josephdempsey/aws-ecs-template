region         = "eu-west-1"
name                = "Name"
environment         = "staging"
cidr = "10.100.120.0/24"
availability_zones  = ["eu-west-1a", "eu-west-1b"]
public_subnets      = ["10.100.120.0/26", "10.100.120.128/26"]
private_subnets     = ["10.100.120.64/26", "10.100.120.192/26"]
// Todo: Update this is a self signed cert, need to buy a domain and update with cert
tsl_certificate_arn = "arn:aws:acm:eu-west-1:698605561725:certificate/TBC"
container_memory    = 2048
container_cpu       = 1024
container_port      = 80
service_desired_count = 1
dockerhub_username  = "docker-user"
dockerhub_repository = "docker-repository"
tags = {
  Terraform   = "true"
  Environment = "staging"
}
domain = "staging.tbc.com"
