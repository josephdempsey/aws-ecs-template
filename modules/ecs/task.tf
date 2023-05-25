data "aws_secretsmanager_secret" "dockerhub" {
  name = var.dockerhub_secret
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "${var.name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

container_definitions = <<DEFINITION
[
  {
    "name": "${var.name}",
    "image": "docker.io/${var.dockerhub_username}/${var.dockerhub_repository}:latest",
    "repositoryCredentials": {
      "credentialsParameter": "${data.aws_secretsmanager_secret.dockerhub.arn}"
    },
    "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.ecs.name}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "ecs-${var.name}"
      }
    },
    "cpu": ${var.container_cpu},
    "memory": ${var.container_memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.container_port},
        "hostPort": ${var.container_port},
        "protocol": "tcp"
      }
    ],
    "healthCheck": {
      "retries": 6,
      "command": [ "CMD-SHELL", "curl -f http://localhost:${var.container_port}/healthcheck || exit 1" ],
      "timeout": 5,
      "interval": 40,
      "startPeriod": 50 
    },
    "secrets": ${jsonencode(var.container_secrets)},
    "environment": [
      {"name": "NODE_ENV", "value": "${var.environment}"}
    ]
  }
]
DEFINITION

  tags = var.tags
}