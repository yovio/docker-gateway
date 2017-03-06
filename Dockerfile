FROM mariadb:10.1
LABEL maintainer "Yovi Oktofianus <yovio@yahoo.com>"

RUN \
      # We'll keep data in /data/mysql/data on first instance and local directory on others (is set locally in container)
	sed -i 's/\/var\/lib\/mysql/\/data\/mysql\/data/g' /etc/mysql/my.cnf

VOLUME \
      /data

