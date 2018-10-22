resource "aws_autoscaling_group" "ecs_instance" {
  vpc_zone_identifier       = ["${data.aws_subnet_ids.private.ids}"]
  name                      = "${aws_launch_configuration.ecs_instance.name}"
  min_size                  = "${var.min_ec2_instances}"
  max_size                  = "${var.max_ec2_instances}"
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.ecs_instance.name}"
  min_elb_capacity          = "${var.min_ec2_instances}"

  tag {
    key                 = "Name"
    value               = "${local.namespace}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["desired_capacity"]
  }
}

resource "aws_autoscaling_policy" "ecs_instance_scale_up" {
  name            = "${local.namespace}-scale-up"
  adjustment_type = "ChangeInCapacity"
  policy_type     = "StepScaling"

  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 0
  }

  autoscaling_group_name = "${aws_autoscaling_group.ecs_instance.name}"
}

resource "aws_autoscaling_policy" "ecs_instance_scale_down" {
  name            = "${local.namespace}-scale-down"
  adjustment_type = "ChangeInCapacity"
  policy_type     = "StepScaling"

  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_upper_bound = 0
  }

  autoscaling_group_name = "${aws_autoscaling_group.ecs_instance.name}"
}

resource "aws_cloudwatch_metric_alarm" "ecs-instance-cpu-high" {
  alarm_name          = "${local.namespace}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.cpu-high-period}"
  statistic           = "Average"
  threshold           = "${var.cpu-high-threshold}"
  alarm_description   = "Monitors ec2 cpu for high use on ${local.namespace} ecs instances"

  alarm_actions = [
    "${aws_autoscaling_policy.ecs_instance_scale_up.arn}",
  ]

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs-instance-cpu-low" {
  alarm_name          = "${local.namespace}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.cpu-low-period}"
  statistic           = "Average"
  threshold           = "${var.cpu-low-threshold}"
  alarm_description   = "Monitors ec2 cpu for low use on ${local.namespace} ecs instances"

  alarm_actions = [
    "${aws_autoscaling_policy.ecs_instance_scale_down.arn}",
  ]

  dimensions {
    ClusterName = "${aws_ecs_cluster.cluster.name}"
  }
}
