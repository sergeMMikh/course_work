output "backend_srv_public_ips" {
  value = [for instance in aws_instance.nginx_srv : instance.public_ip]
}

output "backendn_srv_private_ips" {
  value = [for instance in aws_instance.nginx_srv : instance.private_ip]
}

output "Zabbix_srv_public_ip" {
  value       = aws_instance.Zabbix_srv[0].public_ip
}

output "Zabbix_srv_private_ip" {
  value       = aws_instance.Zabbix_srv[0].private_ip
}

output "Elasticsearch_srv_public_ip" {
  value       = aws_instance.Elasticsearch_srv[0].public_ip
}

output "Elasticsearch_srv_private_ip" {
  value       = aws_instance.Elasticsearch_srv[0].private_ip
}

output "Kibana_srv_public_ip" {
  value       = aws_instance.Kibana_srv[0].public_ip
}

output "Kibana_srv_private_ip" {
  value       = aws_instance.Kibana_srv[0].private_ip
}

output "Bastion_srv_public_ip" {
  value       = aws_instance.Bastion_srv[0].public_ip
}

output "Bastion_srv_private_ip" {
  value       = aws_instance.Bastion_srv[0].private_ip
}