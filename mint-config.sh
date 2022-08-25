#!/usr/bin/bash
# Description: Script for enviroment configuration for Linux Mint 20.1
# Author: Evandro Begati
# Date: 2021/05/11

# Verify for sudo/root execution
if [ "$EUID" -ne 0 ]
  then echo "Por favor, execute o script como sudo!"
  exit
fi

# Get the Real Username
RUID=$(who | awk 'FNR == 1 {print $1}')

# Translate Real Username to Real User ID
RUSER_UID=$(id -u ${RUID})

# Remove unnecessary packages
apt-get purge -y \
  "thunderbird*" \
  "hexchat*" \
  "libreoffice*"

# Full system upgrade
apt-get update
apt-get -f install -y
apt-get dist-upgrade -y

# Install basic packages
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

# Install Windows 10 fonts
sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.fonts
sudo -u $SUDO_USER wget -qO- http://plasmasturm.org/code/vistafonts-installer/vistafonts-installer | sudo -u $SUDO_USER bash
rm -rf /home/$SUDO_USER/PowerPointViewer.exe

apt-get install \
 cabextract \
 ubuntu-restricted-extras \
 remmina \
 zip \
 unzip \
 p7zip-full \
 openjdk-11-jre \
 gimp \
 peek \
 htop \
 zenity \
 git \
 zram-config \
 flameshot \
 firefox-locale-pt \
 gimp-help-pt \
 -y

# Install Wine Packages
dpkg --add-architecture i386
apt-get install -y \
 exe-thumbnailer \
 wine-installer \
 wine32 \
 wine64 \
 winetricks
  
# Install Facilitador Linux
mkdir -p /opt/projetus/facilitador
chmod 777 -R /opt/projetus/facilitador
sudo -u $SUDO_USER git clone https://github.com/projetus-ti/facilitador-linux.git /opt/projetus/facilitador
sudo -u $SUDO_USER chmod -R +x /opt/projetus/facilitador/*.sh
sudo -u $SUDO_USER chmod -R +x /opt/projetus/facilitador/*.desktop
cp /opt/projetus/facilitador/facilitador.desktop /usr/share/applications/facilitador.desktop
sudo -u $USER git config --global --add safe.directory /opt/projetus/facilitador

# Install Discord
wget --no-check-certificate "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
dpkg -i discord.deb
rm -Rf discord.deb

# Install Google Chrome
wget --no-check-certificate "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -O chrome.deb
dpkg -i chrome.deb
rm -Rf chrome.deb

# Install Teamviewer 13
wget --no-check-certificate "https://download.teamviewer.com/download/linux/version_13x/teamviewer_amd64.deb" -O teamviewer.deb
dpkg -i teamviewer.deb
rm -Rf teamviewer.deb

# Install Calima App
wget --no-check-certificate "https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/id3qvymhlwic/b/downloads/o/calima-app/calima-app-2.0.14.deb" -O calima.deb
dpkg -i calima.deb
rm -Rf calima.deb

# Fix remaining dependencies
apt-get -f install -y
rm -Rf /etc/apt/sources.list.d/teamviewer.list

# Add current user to Docker group
usermod -aG docker $SUDO_USER

# Add current user for print group
usermod -aG lpadmin $SUDO_USER

# Fix for IntelliJ/PyCharm
echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf

# Set Swap and Zram
swapoff /swapfile
rm -rf /swapfile
dd if=/dev/zero of=/swapfile bs=8192 count=1048576
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
systemctl enable zram-config
systemctl start zram-config

# Install Windows 10 fonts
sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.fonts
sudo -u $SUDO_USER wget -qO- http://plasmasturm.org/code/vistafonts-installer/vistafonts-installer | sudo -u $SUDO_USER bash

# Install some goodies with flakpak :)
sudo -u $SUDO_USER flatpak update -y --noninteractive
sudo -u $SUDO_USER flatpak install us.zoom.Zoom -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.libreoffice.LibreOffice -y --noninteractive

# Set Chrome for default browser
sudo -u $SUDO_USER xdg-settings set default-web-browser google-chrome.desktop

# Clean
apt clean
apt autoremove -y

# Alert for reboot
clear
read -p "Seu computador será reiniciado, pressione qualquer tecla para continuar..." temp </dev/tty

# Bye :)
reboot
