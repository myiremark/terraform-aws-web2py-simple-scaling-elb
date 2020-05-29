resource "aws_lb" "lb-web" {
  name               = "lb-web"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    data.aws_subnet.app_subnet_1a_public.id,
    data.aws_subnet.app_subnet_1b_public.id,
    data.aws_subnet.app_subnet_1c_public.id
  ]
  security_groups = [
    data.aws_security_group.in_all_http.id,

    data.aws_security_group.out_all.id
  ]
}

resource "aws_lb_target_group" "lb-tg-web" {
  name       = "lb-tg-web"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = data.aws_vpc.app_vpc.id
  slow_start = 180
  health_check {
    path = var.app_ready_check_path
  }
}

resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = aws_lb.lb-web.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg-web.arn
  }
}

