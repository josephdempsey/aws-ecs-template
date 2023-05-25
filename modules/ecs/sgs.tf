resource "aws_security_group" "task" {
  name   = "${var.name}-ecs-task"
  vpc_id = var.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "task_ingress" {
  type                     = "ingress"
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  source_security_group_id = var.lb_security_group_id

  security_group_id = aws_security_group.task.id
}

resource "aws_security_group_rule" "task_egress" {
  type        = "egress"
  from_port   = "0"
  to_port     = "0"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.task.id
}