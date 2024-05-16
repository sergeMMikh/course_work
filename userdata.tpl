#!/bin/bash
sudo apt update -y &&
sudo apt install -y nginx
echo "Server IP:" > /var/www/html/index.html
hostname -I >> /var/www/html/index.html
