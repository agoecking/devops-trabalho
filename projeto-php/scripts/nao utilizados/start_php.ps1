docker run -d `
    --name php-app `
    --network rede-projeto-php `
    -p 80:80 `
    -e DB_HOST=mysql-db `
    -e DB_NAME=dbteste `
    -e DB_USER=appuser `
    -e DB_PASSWORD=senha123 `
    -v ${PWD}:/var/www/html `
    projeto-php