#!/bin/bash
sudo apt update -y &&
sudo apt install -y nginx

# echo "Server IP:" > /var/www/html/index.html
# hostname -I >> /var/www/html/index.html

server_ip=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

cat <<EOF > /var/www/html/index.html
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Backend</title>
</head>
<body>
    <aside>
        <img src="https://avatars.githubusercontent.com/u/25052038?s=200&v=4" alt="Netology" width="50" height="50">
    </aside>
    <main>
        <h2>#  IP: <font color="red">$server_ip</font></h2><br>
        Проект: ${project_name}<br>
        Автор: ${owner}<br>
        Описание: ${description}
    </main>
</body>
</html>
EOF


sudo systemctl start nginx

