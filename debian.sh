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

    #installation zip ; au cas-où
    sudo apt-get install -y unzip

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
    sudo apt-get install -y php-sqlite3
    sudo apt-get install -y php-mbstring
    sudo apt-get install -y php-mysql
    sudo apt-get install -y php-pdo
    sudo apt-get install -y php-xdebug
    sudo apt-get install -y php-intl
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


installJSStack()
{
    #install npm==========================================
    sudo apt-get install -y npm
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






exit 0