#!/bin/bash

# Обновление пакетов и установка необходимых зависимостей
sudo apt update -y

# Установка PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Запуск и настройка PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Загрузка и установка Zabbix репозитория
wget https://repo.zabbix.com/zabbix/6.4/ubuntu-arm64/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu24.04_all.deb
sudo dpkg -i zabbix-release_6.4-1+ubuntu24.04_all.deb
sudo apt update -y

# Установка Zabbix Server, веб-интерфейса и Zabbix Agent
# sudo apt install -y zabbix-server-pgsql zabbix-frontend-php zabbix-apache-conf zabbix-agent
sudo apt install -y zabbix-server-pgsql zabbix-frontend-php php8.3-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent

# Создание пользователя и базы данных для Zabbix
# sudo -u postgres psql -c "CREATE USER zabbix WITH PASSWORD 'zabbixpass';"
su - postgres -c 'psql --command "CREATE USER zabbix WITH PASSWORD zabbixpass;"'
# sudo -u postgres psql -c "CREATE DATABASE zabbix OWNER zabbix;"
su - postgres -c 'psql --command CREATE DATABASE zabbix OWNER zabbix;"'
# sudo -u postgres psql -c "ALTER USER zabbix WITH SUPERUSER;"
su - postgres -c 'psql --command "ALTER USER zabbix WITH SUPERUSER;"'

# Инициализация базы данных Zabbix
sudo zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u postgres psql zabbix

# Настройка Zabbix Server конфигурационного файла
sudo sed -i 's/# DBPassword=/DBPassword=zabbixpass/' /etc/zabbix/zabbix_server.conf

# Перезапуск и включение Zabbix Server и Zabbix Agent
# sudo systemctl restart zabbix-server zabbix-agent
sudo systemctl restart zabbix-server zabbix-agent apache2
# sudo systemctl enable zabbix-server zabbix-agent
sudo systemctl enable zabbix-server zabbix-agent apache2

# Настройка Zabbix frontend
sudo sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone UTC/' /etc/zabbix/apache.conf

# Перезапуск Apache
sudo systemctl restart apache2

# Настройка Zabbix Agent для работы с сервером
sudo sed -i "s/^Server=127.0.0.1/Server=127.0.0.1/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^ServerActive=127.0.0.1/ServerActive=127.0.0.1/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^Hostname=Zabbix server/Hostname=$(hostname)/" /etc/zabbix/zabbix_agentd.conf

# Перезапуск Zabbix Agent
sudo systemctl restart zabbix-agent


# Настройка для прослушивания всех IP-адресов
sudo sed -i 's/# ListenIP=127.0.0.1//' /etc/zabbix/zabbix_server.conf

# Перезапуск и включение Zabbix Server и Zabbix Agent
sudo systemctl restart zabbix-server zabbix-agent
sudo systemctl enable zabbix-server zabbix-agent

# Настройка веб-интерфейса Zabbix
sudo sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone UTC/' /etc/zabbix/apache.conf

# Перезапуск Apache
sudo systemctl restart apache2

# Настройка Zabbix Agent для работы с сервером
sudo sed -i "s/^Server=127.0.0.1/Server=0.0.0.0/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^ServerActive=127.0.0.1/ServerActive=0.0.0.0/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^Hostname=Zabbix server/Hostname=$(hostname)/" /etc/zabbix/zabbix_agentd.conf
