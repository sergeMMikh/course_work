#!/bin/bash

# Обновление пакетов и установка необходимых зависимостей
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoclean -y && sudo apt-get autoremove -y

# Установка PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Запуск и настройка PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Загрузка и установка Zabbix репозитория
wget https://repo.zabbix.com/zabbix/6.0/ubuntu-arm64/pool/main/z/zabbix-release/zabbix-release_6.0-6+ubuntu24.04_all.deb
sudo dpkg -i zabbix-release_6.0-6+ubuntu24.04_all.deb
sudo apt update -y

# Установка Zabbix Server, веб-интерфейса и Zabbix Agent
sudo apt install -y zabbix-server-pgsql zabbix-frontend-php php8.3-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent

# Создание пользователя и базы данных для Zabbix
sudo -u postgres psql -c "CREATE USER zabbix WITH PASSWORD 'zabbixpass';"
sudo -u postgres psql -c "CREATE DATABASE zabbix OWNER zabbix;"
sudo -u postgres psql -c "ALTER USER zabbix WITH SUPERUSER;"

# Инициализация базы данных Zabbix
sudo zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix 

# Настройка Zabbix Server конфигурационного файла
# sudo sed -i 's/# DBPassword=/DBPassword=zabbixpass/' /etc/zabbix/zabbix_server.conf
echo "DBPassword=vrag" | sudo tee -a /etc/zabbix/zabbix_server.conf

# Смена дефолтных портов на zabbix и nginx для отображения zabbix по http
sudo sed -i 's/#        listen          8080;/        listen          80;/g; s/#        server_name     example.com;/        server_name smm_zabbix;/g' /etc/zabbix/nginx.conf
sudo sed -i 's/listen 80[^;]*;/listen 8080;/g' /etc/nginx/sites-available/default

# Перезапуск сервисов
sudo systemctl restart zabbix-server zabbix-agent nginx php8.3-fpm
sudo systemctl enable zabbix-server zabbix-agent nginx php8.3-fpm 
