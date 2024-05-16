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