# scripts/restart-containers.ps1

# Vai para o diretório do script
Set-Location -Path $PSScriptRoot

# Deleta containers antigos
docker rm -f mysql-db php-app flask-api 2>$null

# Cria rede se não existir
docker network create rede-projeto-php 2>$null

# Sobe MySQL
docker run -d `
    --name mysql-db `
    --network rede-projeto-php `
    -e MYSQL_ROOT_PASSWORD=senha123 `
    -e MYSQL_DATABASE=dbteste `
    -e MYSQL_USER=appuser `
    -e MYSQL_PASSWORD=senha123 `
    -p 3306:3306 `
    -v mysql_data:/var/lib/mysql `
    --restart unless-stopped `
    mysql:8.0 `
    --character-set-server=utf8mb4 `
    --collation-server=utf8mb4_unicode_ci `
    --default-authentication-plugin=mysql_native_password

# Sobe app PHP
docker build -t projeto-php ../php-app
docker run -d `
    --name php-app `
    --network rede-projeto-php `
    -p 80:80 `
    -e DB_HOST=mysql-db `
    -e DB_NAME=dbteste `
    -e DB_USER=appuser `
    -e DB_PASSWORD=senha123 `
    -v ${PWD}/../php-app:/var/www/html `
    projeto-php

# Sobe Flask
docker build -t flask-api ../flask-api
docker run -d `
    --name flask-api `
    --network rede-projeto-php `
    -p 5050:5050 `
    flask-api
