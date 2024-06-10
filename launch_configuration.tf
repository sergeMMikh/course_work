resource "aws_launch_configuration" "nginx" {
  name_prefix     = "nginx-launch-configuration-"
  image_id        = data.aws_ami.latest_ubuntu.id
  instance_type   = "t4g.micro"
  security_groups = [aws_security_group.external_net.id]
  user_data = templatefile("lc_userdata.tpl",
    {
      project_name = "Course Work. ",
      description  = "description",
      owner        = "SMMikh"
  })
  lifecycle {
    create_before_destroy = true
  }
}
