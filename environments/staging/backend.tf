provider "aws" {
  region  = "eu-west-1"
}

terraform {
backend "s3" {
    bucket  = "tf-loyalty-state-store-staging"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "eu-west-1"
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "DynamoDB Terraform State Lock Table - tf-loyalty-state-store-staging"
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = true
  }
}