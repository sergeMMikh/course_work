
resource "aws_instance" "test_ubuntu_nginx" {
    count           = 2
    ami             = "ami-099b7bab1b9843525" # Amazon Linux AMI
    instance_type   = "t4g.micro"
    
    key_name        = "mikhalev@DEM-PC1048"

    vpc_security_group_ids = [
        aws_security_group.crystall_sg.id
    ]
    
    user_data       = templatefile("userdata.tpl",
    {
        project_name    = "Course Work. ",
        description     = "description",
        owner           = "SMMikh"
    })    

    tags = {
      Name = "Backend"
      Owner = "SMMikh"
      Project = "Course Work. DevOps Engineer."
    }

    lifecycle {    
        create_before_destroy = true  
        ignore_changes = [user_data]
    }
}

resource "aws_eip" "my_static_ip" {
    count    = 2
    instance = aws_instance.test_ubuntu_nginx[count.index].id
}

## This can be used for generating a new key pair.
# resource "aws_key_pair" "pc1048_ssh" {
#     key_name = "mikhalev@DEM-PC1048"
#     public_key = file("C:/Users/mikhalev/.ssh/id_ed25519.pub")
# }



# Security group
resource "aws_security_group" "crystall_sg" {
  name        = "Web Server Sequrity Group"
  description = "allow ssh on 22 & http on port 80 & backend on 8001 && frontend on 8080"

## This is an internal network identification. It is not needed for now.
## Without this part, AWS uses a default internal network.
#   vpc_id      = aws_default_vpc.default.id 
   
  # Incoming trafic
  dynamic "ingress"{
    for_each = ["80", "443", "22"]
    content {
        from_port        = ingress.value
        to_port          = ingress.value
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }
  }
 
  # Out trafic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
      Name = "Web Server Sequrity Group"
      Owner = "SMMikh"
      Project = "Course Work. DevOps Engineer."
    }
}

output "instance_id" {
  value       = "aws_instance.test_ubuntu_nginx[count.index].id"
  sensitive   = true
  description = "description"
  depends_on  = []
}

output "instance_public_ip" {
  value       = "aws_eip.my_static_ip[count.index].public_ip"
  sensitive   = true
  description = "description"
  depends_on  = []
}