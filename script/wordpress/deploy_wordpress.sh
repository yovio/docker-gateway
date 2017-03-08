#instruction taken from https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lamp-on-ubuntu-16-04

cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /tmp/wordpress/.htaccess
chmod 660 /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir /tmp/wordpress/wp-content/upgrade
cp -a /tmp/wordpress/. /var/www/html

chown -R :www-data /var/www/html

find /var/www/html -type d -exec chmod g+s {} \;
chmod -R g+w /var/www/html/wp-content/themes
chmod -R g+w /var/www/html/wp-content/plugins

sed -i "s/database_name_here/wordpress/g" /var/www/html/wp-config.php
sed -i "s/username_here/wordpressuser/g" /var/www/html/wp-config.php
sed -i "s/password_here/$WP_DB_PASS/g" /var/www/html/wp-config.php

rm /var/www/html/index.html