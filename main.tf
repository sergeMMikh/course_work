resource "aws_instance" "test_ubuntu_nginx" {
    count = 1
    ami = "ami-099b7bab1b9843525" # Amazon Linux AMI
    # instance_type = "t4g.micro"
    instance_type = "t4g.medium" # Usefull for Crystall project

    key_name      = "mikhalev@DEM-PC1048"
    # key_name      = aws_key_pair.pc1048_ssh.key_name

    vpc_security_group_ids = [
        aws_security_group.crystall_sg.id
    ]
    
    # user_data              = file("userdata.tpl")

    tags = {
      Name = "test_ubuntu"
      Owner = "SMMikh"
      Project = "Crystall"
    }
}

# resource "aws_key_pair" "pc1048_ssh" {
#     key_name = "mikhalev@DEM-PC1048"
#     public_key = file("C:/Users/mikhalev/.ssh/id_ed25519.pub")
# }


# Security group
resource "aws_security_group" "crystall_sg" {
  name        = "Crystall server Sequrity Group"
  description = "allow ssh on 22 & http on port 80 & backend on 8001 && frontend on 8080"
#   vpc_id      = aws_default_vpc.default.id # Don't need now
   
  # Incoming trafic
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 8001
    to_port          = 8001
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Out trafic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

