#!/usr/bin/bash
# Description: Script for enviroment configuration for Manjaro 21
# Author: Evandro Begati
# Date: 2021/04/28

# Verify for sudo/root execution
if [ "$EUID" -ne 0 ]
  then echo "Por favor, execute o script como sudo!"
  exit
fi

# Update the system
pacman -Syyu --noconfirm

# Install basic packages
pacman -S \
 breeze-gtk \
 ttf-jetbrains-mono \
 discord telegram-desktop \
 yay \
 base-devel \
 remmina freerdp \
 mtr \
 p7zip \
 jre11-openjdk \
 jdk8-openjdk \
 gnome-boxes \
 docker \
 docker-compose \
 zenity \
 code \
 python-wheel \
 python-virtualenv \
 gimp \
 obs-studio \
 peek \
 kdenlive \
 dbeaver \
 flameshot \
 pycharm-community-edition \
 libreoffice-fresh \
 libreoffice-fresh-pt \
 libreoffice-fresh-pt-br \
 firefox-18n-pt-br \
 thunderbird-i18n-pt-br \
 hunspell-pt_br \
 man-pages-pt_br \
 --noconfirm
 
# Remove unnecessary packages
sudo pacman -R \
 konversation \
 k3b \
 kget \
 --noconfirm

# Install some goodies via AUR
sudo -u $SUDO_USER  yay --save --sudoloop -S \
 ttf-ms-fonts \
 ttf-windows \
 google-chrome \
 anydesk-bin \
 calima-app \
 teamviewer13 \
 postman-bin \
 notion-app \
 zoom \
 skypeforlinux-stable-bin \
 spotify \
 --noconfirm

# Enable Docker service
systemctl enable docker
systemctl start docker

# Enable Teamviewer service
systemctl enable teamviewerd.service
systemctl start teamviewerd.service

# Add current user to docker group
usermod -aG docker $SUDO_USER

# Fix for IntelliJ/PyCharm
echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf

# Add some more ls aliases
sudo -u $SUDO_USER echo "alias ll='ls -alF'" >> ~/.bashrc
sudo -u $SUDO_USER echo "alias la='ls -A'" >> ~/.bashrc
sudo -u $SUDO_USER echo "alias l='ls -CF'" >> ~/.bashrc

# Enable swap
fallocate -l 16G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

# Generate SSH key for git
sudo -u $SUDO_USER ssh-keygen -q -t rsa -N '' -f /home/$SUDO_USER/.ssh/id_rsa
clear
echo "Abra https://bitbucket.org/account/settings/ssh-keys/ no seu browser e faça a adição da chave acima."
echo ""
cat /home/$SUDO_USER/.ssh/id_rsa.pub
echo ""
read -p "Quando estiver pronto, pressione qualquer tecla para continuar... " temp </dev/tty

# Set global git configuration
clear
echo "Agora vamos configurar suas credenciais globais do git."
echo ""
echo "Nome e sobrenome: "
read nome </dev/tty
echo "E-mail: "
read email </dev/tty
sudo -u $SUDO_USER git config --global user.name "$nome"
sudo -u $SUDO_USER git config --global user.email "$email"
clear

# Clean
pacman -Scc --noconfirm

# Alert for reboot
clear
read -p "Seu computador será reiniciado, pressione qualquer tecla para continuar..." temp </dev/tty

# Bye :)
reboot
