# output "backend_srv_public_ips" {
#   value = [for instance in aws_instance.nginx_srv : instance.public_ip]
# }

# output "backendn_srv_private_ips" {
#   value = [for instance in aws_instance.nginx_srv : instance.private_ip]
# }

# output "Zabbix_srv_public_ip" {
#   value       = aws_instance.Zabbix_srv[0].public_ip
# }

# output "Zabbix_srv_private_ip" {
#   value       = aws_instance.Zabbix_srv[0].private_ip
# }

output "Elasticsearch_srv_public_ip" {
  value = aws_instance.Elasticsearch_srv[0].public_ip
}

output "Elasticsearch_srv_private_ip" {
  value = aws_instance.Elasticsearch_srv[0].private_ip
}

output "Kibana_srv_public_ip" {
  value = aws_instance.Kibana_srv[0].public_ip
}

output "Kibana_srv_private_ip" {
  value = aws_instance.Kibana_srv[0].private_ip
}

output "Bastion_srv_public_ip" {
  value = aws_instance.Bastion_srv[0].public_ip
}

output "Bastion_srv_private_ip" {
  value = aws_instance.Bastion_srv[0].private_ip
}

///_________________________________________________________________
data "aws_autoscaling_group" "nginx" {
  name = aws_autoscaling_group.cource-nginx.name
}

data "aws_instance" "nginx_instances" {
  for_each    = toset(data.aws_autoscaling_group.nginx.instances)
  instance_id = each.value
}


#_________________________________________________________
output "nginx_load_balancer_URL" {
  value = aws_elb.server_load_balancer.dns_name
}
