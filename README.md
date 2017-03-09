# docker-gateway

start it with 
docker run -d --name gateway --cap-add SYS_PTRACE -p 8080:8080 -p 8081:8081 -p 8082:8082 -v //docker-data/mysql/data:/var/lib/mysql yovio/docker-gateway:LAMP