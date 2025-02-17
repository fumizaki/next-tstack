resource "aws_lb" "alb" {

    internal = false
    load_balancer_type = "application"
    security_groups = [var.alb_security_group_id]
    subnets = var.public_subnet_ids

    enable_deletion_protection = false

    tags = {
        Name = "${var.project_name}-${var.environment}-alb"
    }
}

resource "aws_lb_target_group" "webview" {
  port = var.webview_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"

  health_check {
    enabled = true
    healthy_threshold = 2
    interval = 30
    matcher = "200"
    path = "/"
    timeout = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.webview.arn
    type = "forward"
  }
}