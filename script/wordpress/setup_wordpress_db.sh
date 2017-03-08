if [ ! -z "$WP_DB_PASS" ]; then	
	echo "Please provide Wordpress db password as $WP_DB_PASS environment variable."
	exit 1
fi

mysql -uroot -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci"
mysql -uroot -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY '$WP_DB_PASS'"