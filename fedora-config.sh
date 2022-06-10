#!/usr/bin/bash
# Description: Script for enviroment configuration for Fedora 40
# Author: Evandro Begati
# Date: 2021/04/29

# Verify for sudo/root execution
if [ "$EUID" -ne 0 ]
  then echo "Por favor, execute o script como sudo!"
  exit
fi

# Get the Real Username
RUID=$(who | awk 'FNR == 1 {print $1}')

# Translate Real Username to Real User ID
RUSER_UID=$(id -u ${RUID})

# Configurar o DNF
#echo 'fastestmirror=1' | tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | tee -a /etc/dnf/dnf.conf

# Enable fstrim
systemctl enable fstrim.timer

# Full system upgrade
dnf upgrade --refresh -y

# Enable RPM Fusion repo
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf group update core -y

# Install basic packages
dnf install \
 remmina \
 nodejs \
 npm \
 filezilla \
 p7zip \
 java-1.8.0-openjdk-devel \
 java-11-openjdk \
 docker \
 docker-compose \
 htop \
 openssh-askpass \
 gnome-extensions-app \
 gnome-tweaks \
 gnome-shell-extension-appindicator \
 fira-code-fonts \
 flameshot \
 zram \
 vlc \
 -y

# Install Python dev packages
dnf install \
 python-wheel \
 python-devel \
 python-virtualenv \
 -y

# Install Windows fonts
dnf install curl cabextract xorg-x11-font-utils fontconfig -y
rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

# Install Windows 10 fonts
sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.fonts
sudo -u $SUDO_USER wget -qO- http://plasmasturm.org/code/vistafonts-installer/vistafonts-installer | sudo -u $SUDO_USER bash

# Install Notion
wget https://notion.davidbailey.codes/notion-linux.repo
mv notion-linux.repo /etc/yum.repos.d/notion-linux.repo
dnf install notion-desktop -y

# Install Google Chrome
dnf install fedora-workstation-repositories -y
dnf config-manager --set-enabled google-chrome
dnf check-update
dnf install google-chrome-stable -y
sudo -u $SUDO_USER xdg-settings set default-web-browser google-chrome.desktop

# Install VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
dnf install code -y

# Install Teamviewer 13
dnf install https://download.teamviewer.com/download/linux/version_13x/teamviewer.x86_64.rpm -y
dnf config-manager --set-disabled teamviewer

# Add current user to Docker group
usermod -aG docker $SUDO_USER

# Enable swap
btrfs subvolume create /var/swap
chattr +C /var/swap
fallocate -l 24G /var/swap/swapfile1
mkswap /var/swap/swapfile1
echo "/var/swap/swapfile1 swap swap defaults 0 0" >> /etc/fstab

# Install PyCharm
dnf config-manager --set-enabled phracek-PyCharm
dnf check-update
dnf install pycharm-community -y
echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf

# Enable flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update

# Instalar pacotes via flatpak
sudo -u $SUDO_USER flatpak install flathub io.dbeaver.DBeaverCommunity -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub com.anydesk.Anydesk -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub com.getpostman.Postman -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub com.spotify.Client -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.qbittorrent.qBittorrent -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub com.simplenote.Simplenote -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub com.uploadedlobster.peek -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gimp.GIMP -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub com.obsproject.Studio -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.telegram.desktop -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub com.discordapp.Discord
sudo -u $SUDO_USER flatpak install flathub org.kde.kdenlive -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub com.github.tchx84.Flatseal -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub us.zoom.Zoom -y --noninteractive
sudo -u $SUDO_USER flatpak update -y --noninteractive

# Set Flameshot as default print screen application
wget --no-check-certificate https://raw.githubusercontent.com/begati/gnome-shortcut-creator/main/gnome-keytool.py -O gnome-keytool.py
sudo -u ${RUID} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'
sudo -u $SUDO_USER python3 gnome-keytool.py 'Print Screen' 'flameshot gui' 'Print'
rm -Rf gnome-keytool.py

# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -rf kubectl

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Adicionar chave SSH ao sistema
update-crypto-policies --set DEFAULT:FEDORA32
sudo -u $SUDO_USER ssh-keygen -q -t rsa -N '' -f /home/$SUDO_USER/.ssh/id_rsa
clear
echo "Abra https://bitbucket.org/account/settings/ssh-keys/ no seu browser e faça a adição da chave acima."
echo ""
cat /home/$SUDO_USER/.ssh/id_rsa.pub
echo ""
read -p "Quando estiver pronto, pressione qualquer tecla para continuar... " temp </dev/tty

# Generate SSH Key for git
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
dnf autoremove -y
pkcon refresh force -c -1

# Alert for reboot
clear
read -p "Seu computador será reiniciado, pressione qualquer tecla para continuar..." temp </dev/tty

# Bye :)
reboot
