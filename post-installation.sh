#!/usr/bin/bash
# Descricao: Script de configuração básica direcionado ao Pop!_OS 20.10
# Autor: Evandro Begati
# Data: 20/01/2021
# Dê permissão de execução e execute com ./post-installation.sh

if [ "$EUID" -ne 0 ]
  then echo "Por favor, execute o script como sudo!"
  exit
fi

# Get the Real Username
RUID=$(who | awk 'FNR == 1 {print $1}')

# Translate Real Username to Real User ID
RUSER_UID=$(id -u ${RUID})

# Atualizar repositorio do apt e resolver instalações pendentes
apt-get update
apt-get -f install -y
apt-get dist-upgrade -y

# Instalar pacotes básicos via apt
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
apt-get install cabextract ubuntu-restricted-extras remmina nodejs npm filezilla p7zip-full virtualbox openjdk-11-jre openjdk-8-jdk git-flow docker.io docker-compose htop zenity ssh-askpass -y

# Dependências Python Dev
apt-get install python3-pip python3-setuptools python3-wheel python3-dev -y

# Instalar o VSCode manualmente
wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode.deb
dpkg -i vscode.deb
rm -Rf vscode.deb

# Instalar o Discord manualmente
wget --no-check-certificate "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
dpkg -i discord.deb
rm -Rf discord.deb

# Instalar o Chrome manualmente
wget --no-check-certificate "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -O chrome.deb
dpkg -i chrome.deb
rm -Rf chrome.deb

# Instalar o Teamviewer 13 manualmennte
wget --no-check-certificate "https://download.teamviewer.com/download/linux/version_13x/teamviewer_amd64.deb" -O teamviewer.deb
dpkg -i teamviewer.deb
apt-get -f install -y
rm -Rf teamviewer.deb
rm -Rf /etc/apt/sources.list.d/teamviewer.list

# Instalar o Calima App manualmente
wget --no-check-certificate "https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/id3qvymhlwic/b/downloads/o/calima-app/calima-app-2.0.7.deb" -O calima.deb
dpkg -i calima.deb
rm -Rf calima.deb

# Adicionar o usuário corrente ao grupo do Docker
usermod -aG docker $SUDO_USER

# Adicionar o usuário corrente ao grupo de impressão
usermod -aG lpadmin $SUDO_USER

# Fix pro IntelliJ/PyCharm
echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf

# Adicionar fontes do Windows 10
sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.fonts
sudo -u $SUDO_USER wget -qO- http://plasmasturm.org/code/vistafonts-installer/vistafonts-installer | sudo -u $SUDO_USER bash

# Instalar pacotes via flatpak
sudo -u $SUDO_USER flatpak update -y --noninteractive
sudo -u $SUDO_USER flatpak install --user https://flathub.org/repo/appstream/com.gigitux.gtkwhats.flatpakref -y --noninteractive
sudo -u $SUDO_USER flatpak install org.ksnip.ksnip -y --noninteractive
sudo -u $SUDO_USER flatpak install io.dbeaver.DBeaverCommunity -y --noninteractive
sudo -u $SUDO_USER flatpak install com.anydesk.Anydesk -y --noninteractive
sudo -u $SUDO_USER flatpak install com.getpostman.Postman -y --noninteractive
sudo -u $SUDO_USER flatpak install com.spotify.Client -y --noninteractive
sudo -u $SUDO_USER flatpak install org.qbittorrent.qBittorrent -y --noninteractive
sudo -u $SUDO_USER flatpak install com.simplenote.Simplenote -y --noninteractive
sudo -u $SUDO_USER flatpak install com.uploadedlobster.peek -y --noninteractive
sudo -u $SUDO_USER flatpak install org.gimp.GIMP -y --noninteractive
sudo -u $SUDO_USER flatpak install com.obsproject.Studio -y --noninteractive
sudo -u $SUDO_USER flatpak install org.telegram.desktop -y --noninteractive
sudo -u $SUDO_USER flatpak install org.kde.kdenlive -y --noninteractive
sudo -u $SUDO_USER flatpak install com.github.tchx84.Flatseal -y --noninteractive
sudo -u $SUDO_USER flatpak install us.zoom.Zoom -y --noninteractive
sudo -u $SUDO_USER flatpak install com.skype.Client -y --noninteractive
sudo -u $SUDO_USER flatpak install org.kde.PlatformTheme.QGnomePlatform//5.15 -y --noninteractive
sudo -u $SUDO_USER flatpak install org.kde.PlatformTheme.QtSNI//5.15 -y --noninteractive
sudo -u $SUDO_USER flatpak remove org.kde.Kstyle.Adwaita -y --noninteractive

# Definir o Chrome como browser padrão
sudo -u $SUDO_USER xdg-settings set default-web-browser google-chrome.desktop

# Habilitar múltiplas áreas de trabalho somente no monitor primário
sudo -u ${RUID} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.mutter workspaces-only-on-primary true

# Configurar o KSnip como o aplicativo de print padrão
wget --no-check-certificate https://raw.githubusercontent.com/begati/gnome-shortcut-creator/main/gnome-keytool.py -O gnome-keytool.py
sudo -u ${RUID} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'
sudo -u $SUDO_USER python3 gnome-keytool.py 'Print Screen' 'flatpak run org.ksnip.ksnip --rectarea' 'Print'
rm -Rf gnome-keytool.py

# Adicionar chave SSH ao sistema
sudo -u $SUDO_USER ssh-keygen -q -t rsa -N '' -f /home/$SUDO_USER/.ssh/id_rsa
clear
echo "Abra https://bitbucket.org/account/settings/ssh-keys/ no seu browser e faça a adição da chave acima."
echo ""
cat /home/$SUDO_USER/.ssh/id_rsa.pub
echo ""
read -p "Quando estiver pronto, pressione qualquer tecla para continuar... " temp </dev/tty

# Configuração das credenciais do git
clear
echo "Agora vamos configurar suas credenciais locais do git."
echo ""
echo "Nome e sobrenome: "  
read nome </dev/tty
echo "E-mail: "  
read email </dev/tty
sudo -u $SUDO_USER git config --global user.name "$nome"
sudo -u $SUDO_USER git config --global user.email "$email"
clear

# Limpeza
apt clean
apt autoremove -y

# Aviso de reboot
clear
read -p "Seu computador será reiniciado, pressione qualquer tecla para continuar..." temp </dev/tty

# Bye :)
reboot
