resource "random_string" "suffix" {
  length  = 9
  special = false
}

resource "aws_s3_bucket" "alb_log" {
  bucket        = "lb-access-log-bucket"
  tags = var.tags
}

resource "aws_s3_bucket_ownership_controls" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "alb_log" {
  depends_on = [aws_s3_bucket_ownership_controls.alb_log]

  bucket = aws_s3_bucket.alb_log.id
  acl    = "private"
}

resource "aws_alb" "primary" {
  name               = "${var.name}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.lb.id]

  tags = var.tags
}

resource "aws_alb_target_group" "primary" {
  name                 = "${var.name}-main-${random_string.suffix.result}"
  port                 = var.container_port
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 120

  health_check {
    protocol            = "HTTP"
    path                = "/healthcheck"
    matcher             = "200-499"
    interval            = "30"
    timeout             = "25"
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

// Todo: Update self signed cert, buy a domain and register a cert
resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.primary.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.alb_tls_cert_arn
  depends_on        = [aws_alb_target_group.primary]

  default_action {
    target_group_arn = aws_alb_target_group.primary.id
    type             = "forward"
  }

  tags = var.tags
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.primary.id
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.primary]

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "Not found"
      status_code  = "404"
    }
  }

  tags = var.tags
}

resource "aws_alb_listener_rule" "main_http_rule" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 1

  action {
    type = "redirect"

    redirect {
      host        = var.domain
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = [var.domain]
    }
  }
}