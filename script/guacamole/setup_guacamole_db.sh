mysql -uroot -e "CREATE DATABASE guacamole DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci"
mysql -uroot -e "GRANT ALL ON guacamole.* TO 'guacamole_user'@'localhost' IDENTIFIED BY '$GUACAMOLE_DB_PASS'"

cat /script/guacamole/*.sql | mysql -u root -p$MYSQL_ROOT_PASS guacamole