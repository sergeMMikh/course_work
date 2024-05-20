# Security group
resource "aws_security_group" "external_net" {
  name        = "Web Server Sequrity Group"
  description = "allow ssh on 22 & http on port 80 & backend on 8001 && frontend on 8080"

  ## This is an internal network identification. It is not needed for now.
  ## Without this part, AWS uses a default internal network.
  #   vpc_id      = aws_default_vpc.default.id 

  # Incoming trafic
  dynamic "ingress" {
    for_each = ["80", "443", "8080", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Out trafic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Web Server Sequrity Group"
    Owner   = "SMMikh"
    Project = "Course Work. DevOps Engineer."
  }
}

