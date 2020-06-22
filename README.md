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
- more bashrc alias
- better apache configuration


