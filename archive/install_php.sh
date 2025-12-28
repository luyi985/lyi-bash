#!/bin/bash 

packages=(nginx php5.6 php5.6-fpm php5.6-cli php5.6-gd php5.6-intl php5.6-mbstring php5.6-mcrypt php5.6-mysqlnd php5.6-pdo php-pear php5.6-xml php5.6-xmlrpc)

echo '1. Update Linux'
echo '-------------------'
sudo apt-get update || return 1
echo '2. Add apt repository'
echo '-------------------'
sudo add-apt-repository ppa:ondrej/php || return 1
echo '3. Update Linux again'
echo '-------------------'
sudo apt-get update || return 1
echo '4 Install package'
echo '-------------------'
for i in ${!packages[@]}
do
	echo "--- Install ${packages[$i]}"
	sudo apt-get install -y ${packages[$i]} || break
done
echo '5 Install apt-file'
echo '-------------------'
sudo apt-get install apt-file || return 1
echo '6 Update apt-file'
echo '-------------------'
apt-file update || return 1
echo '7 Search /usr/bin/pecl'
echo '-------------------'
apt-file search /usr/bin/pecl || return 1
echo '8 Insstall composor'
echo '-------------------'
curl -sS https://getcomposer.org/installer | php
[[ $? -eq 0 ]] || return 1
echo '9 Config composor'
echo '-------------------'
sudo mv composer.phar /usr/local/bin/composer && composer global require drush/drush:8.*
[[ $? -eq 0 ]] || return 1
echo '10 Export path'
echo '-------------------'
export PATH="$HOME/.composer/vendor/drush/drush:$PATH"
echo 'Done'