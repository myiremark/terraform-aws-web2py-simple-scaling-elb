resource "aws_autoscaling_policy" "web-scale-up" {
  name                   = "web-scale-up"
  scaling_adjustment     = 10
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 30
  autoscaling_group_name = aws_autoscaling_group.web.name
}

resource "aws_autoscaling_policy" "web-scale-down" {
  name                   = "web-scale-down"
  scaling_adjustment     = -5
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 180
  autoscaling_group_name = aws_autoscaling_group.web.name
}

