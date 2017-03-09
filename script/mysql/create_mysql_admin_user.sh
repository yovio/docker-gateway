#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

MYSQL_ROOT_PASS=${MYSQL_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MYSQL_PASS} ] && echo "preset" || echo "random" )
echo "=> Creating MySQL admin user with ${_word} password"

mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

# You can create a /mysql-setup.sh file to intialized the DB
if [ -f /mysql-setup.sh ] ; then
  . /mysql-setup.sh
fi

#setup wordpress db
if [ -f /script/wordpress/setup_wordpress_db.sh ] ; then
  . /script/wordpress/setup_wordpress_db.sh
fi

#setup Guacamole db
if [ -f /script/guacamole/setup_guacamole_db.sh ] ; then
  . /script/guacamole/setup_guacamole_db.sh
fi

echo "=> Done!"

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -uadmin -p$MYSQL_ROOT_PASS -h<host> -P<port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"

mysqladmin -uroot shutdown
