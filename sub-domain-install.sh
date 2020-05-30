#!/bin/bash
# GET ALL USER INPUT
tput setaf 2; echo "Domain Name (eg. sub.example.com)?"
read DOMAIN
tput setaf 2; echo "Username (eg. database name)?"
read USERNAME
tput setaf 2; echo "Updating OS................."
sleep 2;
tput sgr0
sudo apt-get update
tput setaf 2; echo "Sit back and relax :) ......"
sleep 1;
tput sgr0
cd /etc/nginx/sites-available/
sudo wget -qO "$DOMAIN" https://raw.githubusercontent.com/bajpangosh/High-Traffic-wordpress-server-configuration/master/sites-available/sub.example.com.conf
sudo sed -i -e "s/sub.example.com/$DOMAIN/" "$DOMAIN"
sudo ln -s /etc/nginx/sites-available/"$DOMAIN" /etc/nginx/sites-enabled/
sudo mkdir -p /var/www/"$DOMAIN"/public
cd /var/www/"$DOMAIN/public"
cd ~
sudo chown www-data:www-data -R /var/www/"$DOMAIN"/public
sudo systemctl restart nginx.service

PASS=`pwgen -s 14 1`

sudo mysql -uroot <<MYSQL_SCRIPT
CREATE DATABASE $USERNAME;
CREATE USER '$USERNAME'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON $USERNAME.* TO '$USERNAME'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo
echo
tput setaf 2; echo "Here is your Credentials"
echo "--------------------------------"
echo "Website:    https://$DOMAIN"
echo
tput setaf 4; echo "Database Name:   $USERNAME"
tput setaf 4; echo "Database Username:   $USERNAME"
tput setaf 4; echo "Database Password:   $PASS"
echo "--------------------------------"
tput sgr0
echo
echo
tput setaf 3;  echo "Installation & configuration succesfully finished."
tput sgr0
