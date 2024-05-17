#!/usr/bin/bash
# Description: Script for enviroment configuration for Fedora 40
# Author: Evandro Begati
# Date: 2024/05/17

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
echo 'fastestmirror=true' | tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=20' | tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | tee -a /etc/dnf/dnf.conf


# Full system upgrade
dnf upgrade --refresh -y

# Enable RPM Fusion repo
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf group update core -y

# Install basic packages
dnf install \
 p7zip \
 java-11-openjdk-devel \
 docker \
 docker-compose \
 oci-cli \
 htop \
 openssh-askpass \
 gnome-extensions-app \
 gnome-tweaks \
 gnome-shell-extension-appindicator \
 gnome-shell-extension-caffeine \
 gnome-shell-extension-dash-to-dock \
 fira-code-fonts \
 adw-gtk3-theme \
 zsh \
 zsh-autosuggestions \
 flameshot \
 -y

# Install Python dev packages
dnf install \
 python-wheel \
 python-setuptools-wheel \
 python-devel \
 python-virtualenv \
 python-pip \
 -y

# Install Windows fonts
dnf install curl cabextract xorg-x11-font-utils fontconfig -y
dnf install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm -y

# Install Windows 10 fonts
sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.fonts
sudo -u $SUDO_USER wget -qO- http://plasmasturm.org/code/vistafonts-installer/vistafonts-installer | sudo -u $SUDO_USER bash

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

# Install OpenLens
wget "https://github.com/MuhammedKalkan/OpenLens/releases/download/v6.5.2-366/OpenLens-6.5.2-366.x86_64.rpm" -O openlens.rpm
dnf install openlens.rpm -y
rm -Rf openlens.rpm

# Install Bitrix24
wget https://dl.bitrix24.com/b24/bitrix24_desktop.rpm -O bitrix.rpm
dnf install bitrix.rpm -y
rm -Rf bitrix.rpm

# Install PyCharm
dnf config-manager --set-enabled phracek-PyCharm
dnf check-update
dnf install pycharm-community -y
echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf

# Install nvm
sudo -u $SUDO_USER curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | sudo -u $SUDO_USER bash

# Enable flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Instalar pacotes via flatpak
sudo -u $SUDO_USER flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
sudo -u $SUDO_USER flatpak install flathub org.flameshot.Flameshot -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub com.uploadedlobster.peek -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.remmina.Remmina -y --noninteractive
sudo -u $SUDO_USER flatpak install io.dbeaver.DBeaverCommunity -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub io.github.mimbrero.WhatsAppDesktop -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub hu.irl.cameractrls -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.gnome.Cheese -y --noninteractive
sudo -u $SUDO_USER flatpak install com.getpostman.Postman -y --noninteractive
sudo -u $SUDO_USER flatpak install com.spotify.Client -y --noninteractive
sudo -u $SUDO_USER flatpak install org.gimp.GIMP -y --noninteractive
sudo -u $SUDO_USER flatpak install com.obsproject.Studio -y --noninteractive
sudo -u $SUDO_USER flatpak install org.telegram.desktop -y --noninteractive
sudo -u $SUDO_USER flatpak install org.kde.kdenlive -y --noninteractive
sudo -u $SUDO_USER flatpak install com.github.tchx84.Flatseal -y --noninteractive
sudo -u $SUDO_USER flatpak install us.zoom.Zoom -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.videolan.VLC -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub com.discordapp.Discord
sudo -u $SUDO_USER flatpak override --filesystem=home com.discordapp.Discord

# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -rf kubectl

# Install kubectx and kubens
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Configure Docker
usermod -aG docker $SUDO_USER
systemctl enable docker
systemctl start docker

# Set adw-gtk3-dark theme for legacy apps
sudo -u $SUDO_USER gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
sudo -u $SUDO_USER gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Allow volume above 100%
sudo -u $SUDO_USER gsettings set org.gnome.desktop.sound allow-volume-above-100-percent 'true'

# Set zsh as default
chsh -s $(which zsh) $(whoami)

# Install OhMyZSH
sudo -u $SUDO_USER sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Adicionar chave SSH ao sistema
sudo -u $SUDO_USER ssh-keygen -q -t ed25519 -N '' -f /home/$SUDO_USER/.ssh/ed25519
clear
echo "Abra https://bitbucket.org/account/settings/ssh-keys/ no seu browser e faça a adição da chave acima."
echo ""
cat /home/$SUDO_USER/.ssh/id_ed25519.pub
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
