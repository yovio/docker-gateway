#instruction taken from https://www.digitalocean.com/community/tutorials/how-to-ssh-into-your-vps-from-the-browser-with-gateone

apt-get -y install python-pip python-openssl python-kerberos  python-concurrent.futures python-html5lib python-tornado debhelper 
pip install --upgrade pip
pip install tornado stdeb

dpkg -i /script/gateone/gateone*.deb

cp /script/gateone/*.conf /etc/gateone/conf.d

service gateone restart