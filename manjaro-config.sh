#!/usr/bin/bash
# Descricao: Script de configuração básica direcionado ao Manjaro 21
# Autor: Evandro Begati
# Data: 20/01/2021
# Dê permissão de execução e execute com ./manjaro-config.sh

if [ "$EUID" -ne 0 ]
  then echo "Por favor, execute o script como sudo!"
  exit
fi

# Get the Real Username
RUID=$(who | awk 'FNR == 1 {print $1}')

# Translate Real Username to Real User ID
RUSER_UID=$(id -u ${RUID})

# Atualizar ambiente
pacman -Syyu --noconfirm

# Pacotes básicos
pacman -S breeze-gtk ttf-jetbrains-mono discord telegram-desktop yay base-devel remmina freerdp mtr p7zip jre11-openjdk jdk8-openjdk docker docker-compose zenity code python-wheel python-virtualenv gimp obs-studio peek kdenlive dbeaver flameshot pycharm-community-edition --noconfirm

# Demais pacotes via AUR
sudo -u $SUDO_USER  yay --save --sudoloop -S ttf-ms-fonts ttf-windows google-chrome anydesk-bin calima-app teamviewer13 postman-bin notion-app zoom skypeforlinux-stable-bin spotify --noconfirm

# Habilitar servicos
systemctl enable docker
systemctl start docker

systemctl enable teamviewerd.service
systemctl start teamviewerd.service

# Adicionar o usuário corrente ao grupo do Docker
usermod -aG docker $SUDO_USER

# Fix pro IntelliJ/PyCharm
echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf

# Configurar Swap
fallocate -l 16G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

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
echo "Agora vamos configurar suas credenciais globais do git."
echo ""
echo "Nome e sobrenome: "
read nome </dev/tty
echo "E-mail: "
read email </dev/tty
sudo -u $SUDO_USER git config --global user.name "$nome"
sudo -u $SUDO_USER git config --global user.email "$email"
clear

# Limpeza
pacman -Scc --noconfirm

# Aviso de reboot
clear
read -p "Seu computador será reiniciado, pressione qualquer tecla para continuar..." temp </dev/tty

# Bye :)
reboot
