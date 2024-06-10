resource "aws_autoscaling_group" "cource-nginx" {
  name                 = "ASG-${aws_launch_configuration.nginx.name}"
  launch_configuration = aws_launch_configuration.nginx.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2

  vpc_zone_identifier = [
    aws_default_subnet.primary.id,
    aws_default_subnet.secondary.id
  ]
  health_check_type = "ELB"
  load_balancers    = [aws_elb.server_load_balancer.name]

  target_group_arns = []

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = {
      name   = "Webserver for cource work by nginx"
      Owner  = "SMMikh"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_lb_target_group" "tg" {
  name                 = "tf-example-lb-tg"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = data.aws_vpc.default.id
  deregistration_delay = 10
}
