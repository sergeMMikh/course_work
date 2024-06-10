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

# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_elb.server_load_balancer.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg.arn
#     # redirect {
#     #   port        = "443"
#     #   protocol    = "HTTPS"
#     #   status_code = "HTTP_301"
#     # }
#   }
# }
