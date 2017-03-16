# docker-gateway

start it with 
docker run -d --name gateway --restart always --cap-add SYS_PTRACE -p 8080:8080 -p 8081:8081 -p 8082:8082 -v //docker-data/mysql/data:/var/lib/mysql -v //docker-data/wp-content:/var/www/html/wp-content yovio/docker-gateway:LAMP

docker run --name nginx --restart always --link gateway:gateway -p 80:80 -p 443:443 -v //docker-data/nginx/nginx.conf:/etc/nginx/nginx.conf:ro -v //docker-data/nginx/ssl:/etc/nginx/ssl:ro -d nginx
