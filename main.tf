resource "aws_security_group" "aws-lb" {
  name   = "fusion-${var.aws_cluster_name}-securitygroup-lb"
  vpc_id = var.aws_vpc_id

  tags = merge(
    var.default_tags,
    {
      "Name" = "fusion-${var.aws_cluster_name}-securitygroup-lb"
    },
  )
}

resource "aws_security_group_rule" "aws-allow-proxy-access" {
  type              = "ingress"
  from_port         = var.aws_lb_proxy_port
  to_port           = var.fusion_secure_proxy_port
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws-lb.id
}

resource "aws_security_group_rule" "aws-allow-proxy-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws-lb.id
}

# Create a new AWS LB for Fusion Proxy
resource "aws_lb" "aws-lb-proxy" {
  name               = "fusion-lb-${var.aws_cluster_name}"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.aws_subnet_ids_public
  security_groups    = [aws_security_group.aws-lb.id]

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = var.aws_lb_logs_s3_bucket
  #   prefix  = "fusion-lb-${var.aws_cluster_name}"
  #   enabled = true
  # }

  idle_timeout = 400

  tags = merge(
    var.default_tags,
    {
      "Name" = "fusion-${var.aws_cluster_name}-lb-proxy"
    },
  )
}

resource "aws_lb_target_group" "aws-lb-tg-proxy" {
  name     = "fusion-lb-tg-${var.aws_cluster_name}"
  port     = var.aws_lb_proxy_port
  protocol = "HTTP"
  vpc_id   = var.aws_vpc_id

  deregistration_delay = 400
  slow_start           = 30

  health_check {
    path                = "/api"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_listener" "aws-lb-listen-proxy" {
  load_balancer_arn = aws_lb.aws-lb-proxy.arn
  port              = var.aws_lb_proxy_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws-lb-tg-proxy.arn
  }
}
