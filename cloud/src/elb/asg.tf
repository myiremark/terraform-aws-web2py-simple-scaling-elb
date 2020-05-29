resource "aws_autoscaling_group" "web" {
  availability_zones        = var.deployed_azs
  name                      = "web"
  max_size                  = var.asg_max_size
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  default_cooldown          = 60
  health_check_type         = "ELB"
  force_delete              = true

  # switch lines below to make all instances public

  # vpc_zone_identifier       = [data.aws_subnet.app_subnet_1a_public.id, data.aws_subnet.app_subnet_1b_public.id, data.aws_subnet.app_subnet_1c_public.id]
  vpc_zone_identifier = [data.aws_subnet.app_subnet_1a_private.id, data.aws_subnet.app_subnet_1b_private.id, data.aws_subnet.app_subnet_1c_private.id]

  launch_configuration = aws_launch_configuration.web.name
  target_group_arns    = [aws_lb_target_group.lb-tg-web.arn]
}

resource "aws_autoscaling_attachment" "asg_attachment_web" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  alb_target_group_arn   = aws_lb_target_group.lb-tg-web.arn
}

