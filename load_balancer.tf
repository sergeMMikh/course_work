resource "aws_elb" "server_load_balancer" {
  name = "nginx-terraform-elb"
  availability_zones = [
    data.aws_availability_zones.av_zone.names[0],
    data.aws_availability_zones.av_zone.names[1]
  ]

  security_groups = [aws_security_group.external_net.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  tags = {
    Name = "cource-work-terraform-elb"
  }

}


