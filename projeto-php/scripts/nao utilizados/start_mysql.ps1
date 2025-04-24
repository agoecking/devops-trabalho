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