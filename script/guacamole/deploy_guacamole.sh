#!/bin/bash

#instruction taken from https://www.chasewright.com/guacamole-with-mysql-on-ubuntu/

VERSION="0.9.11"

apt-get -y install build-essential libcairo2-dev libjpeg-turbo8-dev libpng12-dev libossp-uuid-dev libavcodec-dev libavutil-dev \
libswscale-dev libfreerdp-dev libpango1.0-dev libssh2-1-dev libtelnet-dev libvncserver-dev libpulse-dev libssl-dev \
libvorbis-dev libwebp-dev tomcat8 freerdp ghostscript jq wget curl nano net-tools

# If Apt-Get fails to run completely the rest of this isn't going to work...
if [ $? != 0 ]
then
    echo "apt-get failed to install all required dependencies. Are you on Ubuntu 16.04.01 LTS?"
    exit
fi

# Add GUACAMOLE_HOME to Tomcat8 ENV
echo "" >> /etc/default/tomcat8
echo "# GUACAMOLE EVN VARIABLE" >> /etc/default/tomcat8
echo "GUACAMOLE_HOME=/etc/guacamole" >> /etc/default/tomcat8

# Download Guacample Files
SERVER=$(curl -s 'https://www.apache.org/dyn/closer.cgi?as_json=1' | jq --raw-output '.preferred')
cd /tmp
wget $SERVER/incubator/guacamole/$VERSION-incubating/source/guacamole-server-$VERSION-incubating.tar.gz
wget $SERVER/incubator/guacamole/$VERSION-incubating/binary/guacamole-$VERSION-incubating.war
wget $SERVER/incubator/guacamole/$VERSION-incubating/binary/guacamole-auth-jdbc-$VERSION-incubating.tar.gz
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.40.tar.gz

# Extract Guacamole Files
tar -xzf guacamole-server-$VERSION-incubating.tar.gz
tar -xzf guacamole-auth-jdbc-$VERSION-incubating.tar.gz
tar -xzf mysql-connector-java-5.1.40.tar.gz

# MAKE DIRECTORIES
mkdir /etc/guacamole
mkdir /etc/guacamole/lib
mkdir /etc/guacamole/extensions

# Install GUACD
cd guacamole-server-$VERSION-incubating
./configure --with-init-dir=/etc/init.d
make
make install
ldconfig
systemctl enable guacd
cd ..

# Move files to correct locations
mv guacamole-$VERSION-incubating.war /etc/guacamole/guacamole.war
ln -s /etc/guacamole/guacamole.war /var/lib/tomcat8/webapps/
ln -s /usr/local/lib/freerdp/* /usr/lib/x86_64-linux-gnu/freerdp/.
cp mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar /etc/guacamole/lib/
cp guacamole-auth-jdbc-$VERSION-incubating/mysql/guacamole-auth-jdbc-mysql-$VERSION-incubating.jar /etc/guacamole/extensions/

# Configure guacamole.properties
echo "mysql-hostname: localhost" >> /etc/guacamole/guacamole.properties
echo "mysql-port: 3306" >> /etc/guacamole/guacamole.properties
echo "mysql-database: guacamole" >> /etc/guacamole/guacamole.properties
echo "mysql-username: guacamole_user" >> /etc/guacamole/guacamole.properties
echo "mysql-password: $GUACAMOLE_DB_PASS" >> /etc/guacamole/guacamole.properties
rm -rf /usr/share/tomcat8/.guacamole
ln -s /etc/guacamole /usr/share/tomcat8/.guacamole

# copy Guacamole Schema to script folder to be execute later when create db
cp guacamole-auth-jdbc-$VERSION-incubating/mysql/schema/*.sql /script/guacamole

# Cleanup
rm -rf guacamole-*
rm -rf mysql-connector-java-5.1.40*
