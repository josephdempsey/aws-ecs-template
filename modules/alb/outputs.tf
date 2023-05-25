output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.primary.arn
}

output "lb_security_group_id" {
  value = aws_security_group.lb.id
}