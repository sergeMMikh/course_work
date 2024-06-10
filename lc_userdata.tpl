#!/bin/bash
sudo apt update -y &&
sudo apt install -y nginx curl net-tools

myip=`curl https://ipinfo.io/ip`

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
        <h2>#  IP: <font color="red">$myip</font></h2><br>
        Проект: ${project_name}<br>
        Автор: ${owner}<br>
        Описание: ${description}
    </main>
</body>
</html>
EOF


sudo systemctl start nginx