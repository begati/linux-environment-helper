#!/usr/bin/bash
# Description: Script for enviroment configuration for Linux Mint 22
# Author: Evandro Begati
# Date: 2021/05/11

# Verify for sudo/root execution
if [ "$EUID" -ne 0 ]
  then echo "Por favor, execute o script como sudo!"
  exit
fi

# Auto accept EULA for MS TTF
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

# Full system upgrade
apt-get update
apt-get -f install -y
apt-get dist-upgrade -y

# Install base packages
apt-get install -y \
 cabextract \
 ubuntu-restricted-extras \
 gnome-boxes \
 p7zip-full \
 zip \
 unzip \
 p7zip-full \
 openjdk-17-jre \
 git \
 git-flow \
 docker.io \
 docker-compose \
 htop \
 zenity \
 ssh-askpass \
 zram-config \
 zsh \
 fonts-firacode
 
# Install Python dev packages
apt-get install \
 python3-pip \
 python3-setuptools \
 python3-venv \
 python3-wheel \
 python3-dev \
 python3-virtualenv \
 -y

# Install Windows 10 fonts
sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.fonts
sudo -u $SUDO_USER wget -qO- http://plasmasturm.org/code/vistafonts-installer/vistafonts-installer | sudo -u $SUDO_USER bash
rm -rf /home/$SUDO_USER/PowerPointViewer.exe
  
# Install Facilitador Linux
# curl -s https://raw.githubusercontent.com/projetus-ti/facilitador-linux/master/install.sh | bash

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

# Install VSCode
wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode.deb
dpkg -i vscode.deb
rm -Rf vscode.deb

# Install OpenLens
wget "https://github.com/MuhammedKalkan/OpenLens/releases/download/v$(curl -L -s https://raw.githubusercontent.com/MuhammedKalkan/OpenLens/main/version)/OpenLens-$(curl -L -s https://raw.githubusercontent.com/MuhammedKalkan/OpenLens/main/version).amd64.deb" -O openlens.deb
dpkg -i openlens.deb
rm -Rf openlens.deb

# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -rf kubectl

# Install Bitrix24
wget https://dl.bitrix24.com/b24/bitrix24_desktop.deb -O bitrix.deb
dpkg -i bitrix.deb
rm -Rf bitrix.deb

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Install kubectx and kubectl
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Fix remaining dependencies
apt-get -f install -y
rm -Rf /etc/apt/sources.list.d/teamviewer.list

# Add current user for print group
usermod -aG lpadmin $SUDO_USER

# Add current user to Docker group
usermod -aG docker $SUDO_USER

# Fix for IntelliJ/PyCharm
echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf

# Install Windows 10 fonts
sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.fonts
sudo -u $SUDO_USER wget -qO- http://plasmasturm.org/code/vistafonts-installer/vistafonts-installer | sudo -u $SUDO_USER bash

# Install some goodies with flakpak :)
sudo -u $SUDO_USER flatpak install flathub org.flameshot.Flameshot -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub com.uploadedlobster.peek -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.remmina.Remmina -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.flameshot.Flameshot -y --noninteractive
sudo -u $SUDO_USER flatpak install io.dbeaver.DBeaverCommunity -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub io.github.mimbrero.WhatsAppDesktop
sudo -u $SUDO_USER flatpak install flathub hu.irl.cameractrls -y --noninteractive
sudo -u $SUDO_USER flatpak install com.getpostman.Postman -y --noninteractive
sudo -u $SUDO_USER flatpak install com.spotify.Client -y --noninteractive
sudo -u $SUDO_USER flatpak install org.gimp.GIMP -y --noninteractive
sudo -u $SUDO_USER flatpak install com.obsproject.Studio -y --noninteractive
sudo -u $SUDO_USER flatpak install org.telegram.desktop -y --noninteractive
sudo -u $SUDO_USER flatpak install org.kde.kdenlive -y --noninteractive
sudo -u $SUDO_USER flatpak install com.github.tchx84.Flatseal -y --noninteractive
sudo -u $SUDO_USER flatpak install us.zoom.Zoom -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.videolan.VLC -y --noninteractive
sudo -u $SUDO_USER flatpak update -y --noninteractive

# Clean
apt clean
apt autoremove -y

# Generate SSH Key for git
sudo -u $SUDO_USER ssh-keygen -q -t rsa -N '' -f /home/$SUDO_USER/.ssh/id_rsa
clear
echo "Abra https://bitbucket.org/account/settings/ssh-keys/ no seu browser e faça a adição da chave acima."
echo ""
cat /home/$SUDO_USER/.ssh/id_rsa.pub
echo ""
read -p "Quando estiver pronto, pressione qualquer tecla para continuar... " temp </dev/tty

# Set global git configuration
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

# Set Chrome for default browser
sudo -u $SUDO_USER xdg-settings set default-web-browser google-chrome.desktop

# Install OhMyZSH
sudo -u $SUDO_USER sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# OhMyZSH plugins
sudo -u $SUDO_USER git clone https://github.com/zsh-users/zsh-autosuggestions /home/$SUDO_USER/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sudo -u $SUDO_USER git clone https://github.com/mattberther/zsh-pyenv /home/$SUDO_USER/.oh-my-zsh/custom/plugins/zsh-pyenv

# Install Oracle cli
sudo -u $SUDO_USER bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"

# Alert for reboot
clear
read -p "Seu computador será reiniciado, pressione qualquer tecla para continuar..." temp </dev/tty

# Bye :)
reboot
