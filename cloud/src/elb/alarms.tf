resource "aws_cloudwatch_metric_alarm" "cpu-high" {
  alarm_name          = "cpu-high-web"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  # min period of AWS/EC2 namespace is 60 s
  period            = "60"
  statistic         = "Average"
  threshold         = "40"
  alarm_description = "CPU has been more than 40% 1 time in the past 60 seconds"
  alarm_actions = [
    aws_autoscaling_policy.web-scale-up.arn
  ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu-low-web" {
  alarm_name          = "cpu-low-web"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  # min period of AWS/EC2 namespace is 60 s
  period            = "60"
  statistic         = "Average"
  threshold         = "10"
  alarm_description = "CPU has been less than 10% 1 time in the past 60 seconds"
  alarm_actions = [
    aws_autoscaling_policy.web-scale-down.arn
  ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
}

