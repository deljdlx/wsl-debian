# WSL Debian Lamp

## Intallation
Dowload wsl image https://drive.google.com/file/d/1mAeNE9SsicZVdUgRW3LXrgOFX6MZnAvH/view?usp=sharing

Import wsl : run command in Powershell. Think to replace **{DestinationFolder}** and **{DownloadFolder}**

```sh
wsl --import DebianLamp {DestinationFolder} {DownloadFolder}\Debian.wsl.tar.gz
```

Start wsl with Powershell
```sh
wsl -d DebianLamp
```

## Configuration
### Unix
- User : ```debian```
- Password : ```quatrea```

### MySQL
- User: ```debian```
- Password : ```aaaa```

### Windows intégration

#### Integrate apache root
Replace **{WINDOWS_SHARED_DISK}** and **{WINDOWS_SHARED_FOLDER}** by correct values

```sh
mkdir /tmp/www-backup
sudo mv /var/www/html/* /tmp/www-backup
sudo rm -rf /var/www/html
sudo ln -s /mnt/{WINDOWS_SHARED_DISK}/{WINDOWS_SHARED_FOLDER} /var/www/html
sudo mv /tmp/www-backup/* /var/www/html

sudo chown -R $USER:www-data /var/www/html
sudo chmod -R 775 /var/www/html

```



### Installed softwares

- Apache2
- MariaDB
- PHP7.3
    - adminer
    - composer
- NPM
- Git
- ...

### Todo
- Better readme
- more bashrc alias
- better apache configuration


### Misc
Clean Debian install script : https://github.com/deljdlx/wsl-debian/blob/master/debian.sh

Save this file, then run

```sh
sh debian.sh
```


