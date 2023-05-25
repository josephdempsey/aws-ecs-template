resource "aws_ecs_service" "service" {
  name                               = "${var.name}-service"
  cluster                            = aws_ecs_cluster.ecs.id
  task_definition                    = aws_ecs_task_definition.task_def.arn
  desired_count                      = var.service_desired_count
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  launch_type                        = "FARGATE"
  health_check_grace_period_seconds  = 15

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = var.name
    container_port   = var.container_port
  }

  network_configuration {
    security_groups = [aws_security_group.task.id]
    subnets         = var.private_subnets
    assign_public_ip = false
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

  tags = var.tags
}





