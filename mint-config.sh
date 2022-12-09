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

# Install Microsoft Fonts
mkdir -p /usr/share/fonts/truetype/msttcorefonts
mkdir -p /tmp/ttf

wget "https://mirrors.kernel.org/gentoo/distfiles/andale32.exe" -O /tmp/ttf/andale32.exe
wget "https://mirrors.kernel.org/gentoo/distfiles/arial32.exe" -O /tmp/ttf/arial32.exe
wget "https://mirrors.kernel.org/gentoo/distfiles/arialb32.exe" -O /tmp/ttf/arialb32.exe
wget "https://mirrors.kernel.org/gentoo/distfiles/comic32.exe" -O /tmp/ttf/comic32.exe
wget "https://mirrors.kernel.org/gentoo/distfiles/courie32.exe" -O /tmp/ttf/courie32.exe
wget "https://mirrors.kernel.org/gentoo/distfiles/georgi32.exe" -O /tmp/ttf/georgi32.exe
wget "https://mirrors.kernel.org/gentoo/distfiles/impact32.exe" -O /tmp/ttf/impact32.exe
wget "https://mirrors.kernel.org/gentoo/distfiles/times32.exe" -O /tmp/ttf/times32.exe
wget "https://mirrors.kernel.org/gentoo/distfiles/trebuc32.exe" -O /tmp/ttf/trebuc32.exe
wget "https://mirrors.kernel.org/gentoo/distfiles/verdan32.exe" -O /tmp/ttf/verdan32.exe
wget "https://mirrors.kernel.org/gentoo/distfiles/webdin32.exe" -O /tmp/ttf/webdin32.exe
wget "https://raw.githubusercontent.com/PrincetonUniversity/COS333_Comet/master/android/app/src/main/assets/fonts/Microsoft%20Sans%20Serif.ttf" -O /usr/share/fonts/truetype/msttcorefonts/ms-sans-serif.ttf 

cabextract /tmp/ttf/*.exe -d /tmp/ttf
cp /tmp/ttf/*.TTF /usr/share/fonts/truetype/msttcorefonts
rm -rf /tmp/ttf
fc-cache -fv
  
# Install Facilitador Linux
curl -s https://raw.githubusercontent.com/projetus-ti/facilitador-linux/master/install.sh | sudo bash

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
wget --no-check-certificate "https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/id3qvymhlwic/b/downloads/o/calima-app/calima-app-2.0.15.deb" -O calima.deb
dpkg -i calima.deb
rm -Rf calima.deb

# Fix remaining dependencies
apt-get -f install -y
rm -Rf /etc/apt/sources.list.d/teamviewer.list

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

# Flatpak desktop integration with Linux Mint
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Teal  -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Red -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Purple -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Pink -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Orange -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Grey -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Darker -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Darker-Teal -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Darker-Sand -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Darker-Red -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Darker-Purple -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Darker-Pink -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Darker-Orange -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Darker-Grey -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Darker-Brown -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Darker-Blue -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Darker-Aqua -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark-Teal -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark-Sand -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark-Red -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark-Purple -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark-Pink -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark-Orange -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark-Grey -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark-Brown -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark-Blue -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark-Aqua -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Brown -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Blue -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Aqua -y --noninteractive

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
