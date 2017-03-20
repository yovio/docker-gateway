# docker-gateway

start it with 


docker run -d --name gateway --restart always --cap-add SYS_PTRACE -p 8080:8080 -p 8081:8081 -p 8082:8082 -v //docker-data/mysql/data:/var/lib/mysql yovio/docker-gateway:LAMP

docker run -d --name=gateone --restart always -p 8000:8000 liftoff/gateone sh -c 'sed -i "s/\"disable_ssl\": false/\"disable_ssl\": true/g" /etc/gateone/conf.d/10server.conf && /usr/local/bin/update_and_run_gateone --log_file_prefix=/gateone/logs/gateone.log'

docker run --name nginx --restart always --link gateway:gateway --link wordpress:wordpress --link guacamole:guacamole --link gateone:gateone -p 80:80 -p 443:443 -v //docker-data/nginx/nginx.conf:/etc/nginx/nginx.conf:ro -v //docker-data/nginx/ssl:/etc/nginx/ssl:ro -d nginx