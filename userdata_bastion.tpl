#!/bin/bash
sudo apt update -y
sudo apt install -y ansible

cat <<EOF >> /etc/hosts

# Infrastructure servers
${backend_1_private_ip}  backend_1
${backend_2_private_ip}  backend_2
${zabbix_srv_private_ip} zabbix_srv
${elasticsearch_srv_private_ip} elasticsearch_srv
${kibana_srv_public_ip} kibana_srv

EOF