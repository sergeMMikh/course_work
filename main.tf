resource "aws_instance" "nginx_srv" {
  count = 2
  # ami             = "ami-099b7bab1b9843525" # Amazon Linux AMI
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t4g.micro"

  key_name = "mikhalev@DEM-PC1048"

  vpc_security_group_ids = [
    aws_security_group.external_net.id
  ]

  user_data = templatefile("userdata.tpl",
    {
      project_name = "Course Work. ",
      description  = "description",
      owner        = "SMMikh"
  })

  tags = {
    Name    = "Backend"
    Owner   = "SMMikh"
    Project = "Course Work. DevOps Engineer."
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
}

resource "aws_instance" "Zabbix_srv" {
  count         = 1
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t4g.micro"

  key_name = "mikhalev@DEM-PC1048"

  vpc_security_group_ids = [
    aws_security_group.external_net.id
  ]

  user_data = templatefile("userdata_zabbix.tpl",
    {
      hostname = "zabbix_srv"
  })

  tags = {
    Name    = "Zabbix"
    Owner   = "SMMikh"
    Project = "Course Work. DevOps Engineer."
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
}

resource "aws_instance" "Elasticsearch_srv" {
  count         = 1
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t4g.micro"

  key_name = "mikhalev@DEM-PC1048"

  vpc_security_group_ids = [
    aws_security_group.internal_net.id
  ]

  user_data = templatefile("userdata_elasticsearch.tpl",
  {})

  tags = {
    Name    = "Elasticsearch"
    Owner   = "SMMikh"
    Project = "Course Work. DevOps Engineer."
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
}

resource "aws_instance" "Kibana_srv" {
  count         = 1
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t4g.micro"

  key_name = "mikhalev@DEM-PC1048"

  vpc_security_group_ids = [
    aws_security_group.external_net.id
  ]

  user_data = templatefile("userdata_kibana.tpl",
  {})

  tags = {
    Name    = "Kibana"
    Owner   = "SMMikh"
    Project = "Course Work. DevOps Engineer."
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
}

resource "aws_instance" "Bastion_srv" {
  count         = 1
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t4g.micro"

  key_name = "mikhalev@DEM-PC1048"

  vpc_security_group_ids = [
    aws_security_group.external_net.id
  ]

  user_data = templatefile("userdata_bastion.tpl",
    {
      backend_1_private_ip         = aws_instance.nginx_srv[0].private_ip,
      backend_2_private_ip         = aws_instance.nginx_srv[1].private_ip,
      zabbix_srv_private_ip        = aws_instance.Zabbix_srv[0].private_ip,
      elasticsearch_srv_private_ip = aws_instance.Elasticsearch_srv[0].private_ip,
      kibana_srv_public_ip         = aws_instance.Kibana_srv[0].public_ip
  })

  tags = {
    Name    = "Bastion"
    Owner   = "SMMikh"
    Project = "Course Work. DevOps Engineer."
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data]
  }

  depends_on = [
    aws_instance.nginx_srv,
    aws_instance.Zabbix_srv,
    aws_instance.Elasticsearch_srv,
    aws_instance.Kibana_srv
  ]
}

# Elastic IP
resource "aws_eip" "base_static_ip" {
  count    = 2
  instance = aws_instance.nginx_srv[count.index].id
}

## This can be used for generating a new key pair.
# resource "aws_key_pair" "pc1048_ssh" {
#     key_name = "mikhalev@DEM-PC1048"
#     public_key = file("C:/Users/mikhalev/.ssh/id_ed25519.pub")
# }
