USER_NAME=$USER
BDD_USER_NAME=$USER_NAME
BDD_USER_PASSWORD="aaaa"



installEssentials()
{
    #mise à jour de la base logicielle===============
    sudo apt-get update

    #mise à jour des logiciels préinstallés===========
    sudo apt-get -y upgrade

    #installation de vim (est généralement préinstallé)==
    sudo apt-get install -y vim

    #installation de wget (est généralement préinstallé)==
    sudo apt-get install -y wget

    #curl
    sudo apt-get install -y curl


    #installation zip ; au cas-où
    sudo apt-get install -y unzip

    #imagemagick
    sudo apt-get install -y imagemagick
    

}


installFishShell()
{
    echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' | sudo tee -a /etc/apt/sources.list
    wget -q -O - https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key | sudo apt-key add -
    sudo apt update
    sudo apt install fish
}

reinitMySQL()
{
    sudo mysql_install_db --user=mysql
}


installApache()
{
    #installation apache==============================
    sudo apt-get install -y apache2

    #activation du mod rewrite pour les htaccess=======
    sudo a2enmod rewrite
    sudo service apache2 restart
}

configureApache()
{
    #configuration apache=========================
    #sudo vim /etc/apache2/apache2.conf
    #sudo nano /etc/apache2/apache2.conf
    #<Directory /var/www/>
    #	Options Indexes FollowSymLinks
    #	AllowOverride All
    #	Require all granted
    #</Directory>
    #sudo service apache2 restart

    sudo php -r "file_put_contents('/etc/apache2/apache2.conf', str_replace('AllowOverride None', 'AllowOverride All', file_get_contents('/etc/apache2/apache2.conf')));"

    #configuration des droits=====================
    #remplacer ubuntu par le votre nom d'utilisateur
    sudo chown -R $USER_NAME:www-data /var/www/html
    sudo chmod -R 775 /var/www/html
    sudo rm -rf /var/www/html/index.html
    sudo service apache2 restart
}

installPHP()
{
    #installation php========================
    sudo apt-get install -y php
    sudo apt-get install -y php-zip
    sudo apt-get install -y php-gd
    sudo apt-get install -y php-xml
    sudo apt-get install -y php-simplexml
    sudo apt-get install -y php-sqlite3
    sudo apt-get install -y php-mbstring
    sudo apt-get install -y php-mysql
    sudo apt-get install -y php-pdo
    sudo apt-get install -y php-xdebug
    sudo apt-get install -y php-intl
    sudo apt-get install -y php-curl
    sudo apt-get install -y php-imagick
    sudo service apache2 restart
}

installPHPTools()
{
    #composer===================================================
    #attention c'est une installation bourrine de composer...
    cd /tmp
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php --quiet
    sudo mv composer.phar /usr/local/bin/composer

    #installatin phpcs=========================================
    wget -O phpcs.phar https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
    sudo chmod a+x phpcs.phar
    sudo mv phpcs.phar /usr/local/bin/phpcs.phar

    #installatin cs-fixer=========================================
    cd /tmp
    wget https://cs.symfony.com/download/php-cs-fixer-v2.phar -O php-cs-fixer
    sudo chmod a+x php-cs-fixer
    sudo mv php-cs-fixer /usr/local/bin/php-cs-fixer


    #installation adminer
    mkdir /var/www/html/adminer
    wget https://github.com/vrana/adminer/releases/download/v4.7.7/adminer-4.7.7.php
    mv adminer-4.7.7.php /var/www/html/adminer/index.php


    #création d'un fichier phpinfo pour vérifier la configuration=========
    sudo echo "<?php phpinfo(); " > /var/www/html/phpinfo.php
}

configurePHP()
{
    sudo php -r "\$ini=glob('/etc/php/*/apache2/php.ini')[0]; \$buffer=file_get_contents(\$ini); \$buffer=str_replace('display_errors = Off', 'display_errors = On',\$buffer); file_put_contents(\$ini, \$buffer);";
    sudo service apache2 restart
}


installMySQL()
{
    #installation mariadb-server============
    sudo apt-get install -y mariadb-server
    sudo service mysql start
}

configureMysql()
{
    #configuration mysql=====================
    #sudo mysql
    #CREATE USER 'aventurier'@'localhost' IDENTIFIED BY 'Ereul9Aeng';
    #GRANT ALL PRIVILEGES ON *.* TO 'aventurier'@'localhost';
    #sudo vim /etc/mysql/mariadb.conf.d/50-server.cnf
    #sudo service mysql restart

    sudo mysql -e"CREATE USER '$BDD_USER_NAME'@'localhost' IDENTIFIED BY '$BDD_USER_PASSWORD';" mysql
    sudo mysql -e"GRANT ALL PRIVILEGES ON *.* TO '$BDD_USER_NAME'@'localhost';" mysql
    sudo service mysql restart
}

installGit()
{
    #installation de git ; mais généralement est préinstallé===========
    sudo apt-get install -y git
    git config --global user.email "$USER_NAME@wsl.local"
    git config --global user.name "$USER_NAME"
}


configureProfile()
{
    sudo touch /etc/wsl.conf
    echo '[user]' | sudo tee -a /etc/wsl.conf
    echo "default=$USER_NAME" | sudo tee -a /etc/wsl.conf

    #customisation .bashrc
    echo 'alias sss="sudo service apache2 start; sudo service mysql start"' >> ~/.bashrc
    echo 'alias www="cd /var/www/html"' >> ~/.bashrc

    #création d'une paire de clés ssh ; se crée dans ~/.ssh par défaut===
    #ssh-keygen -q -t rsa -b 4096 -C "$USER_NAME@wsl.local" -N '' -f ~/.ssh/id_rsa <<< Y
    echo 'eval `ssh-agent -s`' >> ~/.bashrc

    . ~/.bashrc

}


installNPM()
{
    #install npm==========================================
    #https://github.com/nodesource/distributions/blob/master/README.md
    cd /tmp
    curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
    sudo apt-get install -y nodejs

    mkdir ~/.npm-global
    npm config set prefix '~/.npm-global'
    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
    source ~/.profile
    npm install -g jshint
}


installVueJS()
{
    npm install -g @vue/cli
}

#==========================================================================================
#==========================================================================================
#==========================================================================================


installEssentials
installApache
installPHP
installMySQL

configureApache
configurePHP
configureMysql

installPHPTools

configureProfile

installGit

installJSStack


#sudo apt-get install -y debconf
#sudo /usr/sbin/dpkg-reconfigure locales
#apt-get install xfce4
#sudo apt-get install -y openssh-server
#dpkg-reconfigure locales


#su -
#usermod -aG sudo debian



#sudo apt install software-properties-common apt-transport-https curl
#curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
#sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
#sudo apt update
#sudo apt install code



#sudo vim /etc/group
#vboxsf:x:1001:www-data

#sudo apt install build-essential dkms linux-headers-$(uname -r)
#sudo mkdir -p /mnt/cdrom
#sudo mount /dev/cdrom /mnt/cdrom
#sudo sh ./VBoxLinuxAdditions.run --nox11

#npm install -g yo generator-code

exit 0