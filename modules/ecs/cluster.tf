resource "aws_kms_key" "ecs" {
  description             = "ecs-kms-key"
  deletion_window_in_days = 7

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = var.name
  tags = var.tags
}

resource "aws_ecs_cluster" "ecs" {
  name = "${var.name}-cluster"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.ecs.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs.name
        s3_bucket_encryption_enabled = true
      }
    }
  }

  tags = var.tags
}