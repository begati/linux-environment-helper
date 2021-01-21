#!/bin/bash
# Descricao: Script de configuração básica direcionado ao Pop!_OS 20.10
# Autor: Evandro Begati
# Data: 20/01/2021
# Dê permissão de execução e execute com ./post-installation.sh

if [ "$EUID" -ne 0 ]
  then echo "Por favor, execute o script como sudo!"
  exit
fi

# Atualizar repositorio do apt e resolver instalações pendentes
apt update
apt -f install
apt dist-upgrade -y

# Instalar pacotes via apt
apt install ubuntu-restricted-extras nodelts npm filezilla virtualbox openjdk-11-jre \
openjdk-8-jre docker.io docker-compose htop zenity ssh-askpass -y

# Instalar o Discord manualmente
wget --no-check-certificate "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
dpkg -i discord.deb
rm -Rf discord.deb

# Instalar o VS Code manualmente
wget --no-check-certificate "https://code.visualstudio.com/docs/?dv=linux64_deb" -O vscode.deb
dpkg -i discord.deb
rm -Rf discord.deb

# Instalar o Chrome manualmente
wget --no-check-certificate "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -O chrome.deb
dpkg -i chrome.deb
rm -Rf chrome.deb

# Instalar o Calima App manualmente
wget --no-check-certificate "https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/id3qvymhlwic/b/downloads/o/calima-app/calima-app-2.0.7.deb" -O calima.deb
dpkg -i calima.deb
rm -Rf calima.deb

# Adicionar o usuário corrente ao grupo do Docker
usermod -aG docker $SUDO_USER

# Adicionar o usuário corrente ao grupo de impressão
usermod -aG lpadmin $SUDO_USER

# Adicionar fontes do Windows 10
mkdir /home/$SUDO_USER/.fonts
sudo -u $SUDO_USER wget -qO- http://plasmasturm.org/code/vistafonts-installer/vistafonts-installer | sudo -u $SUDO_USER bash

# Instalar pacotes via flatpak
sudo -u $SUDO_USER flatpak install org.ksnip.ksnip -y
sudo -u $SUDO_USER flatpak install io.dbeaver.DBeaverCommunity -y
sudo -u $SUDO_USER flatpak install com.anydesk.Anydesk -y
sudo -u $SUDO_USER flatpak install com.getpostman.Postman -y
sudo -u $SUDO_USER flatpak install com.spotify.Client -y
sudo -u $SUDO_USER flatpak install com.simplenote.Simplenote -y
sudo -u $SUDO_USER flatpak install com.uploadedlobster.peek -y
sudo -u $SUDO_USER flatpak install org.gimp.GIMP -y
sudo -u $SUDO_USER flatpak install com.obsproject.Studio -y
sudo -u $SUDO_USER flatpak install org.telegram.desktop -y
sudo -u $SUDO_USER flatpak install org.kde.kdenlive -y
sudo -u $SUDO_USER flatpak install com.jetbrains.PyCharm-Community -y
sudo -u $SUDO_USER flatpak install com.github.tchx84.Flatseal -y

# Definiir o Chrome como browser padrão
sudo -u $SUDO_USER xdg-settings set default-web-browser google-chrome.desktop

# Configurar o KSnip como o aplicativo de print padrão
wget --no-check-certificate https://raw.githubusercontent.com/begati/gnome-shortcut-creator/main/gnome-keytool.py -O gnome-keytool.py
sudo -u $SUDO_USER python3 gnome-keytool.py 'Print Screen' 'flatpak run org.ksnip.ksnip --rectarea' 'Print'
sudo -u $SUDO_USER python3 gnome-keytool.py 'Print Screen Delay' 'flatpak run org.ksnip.ksnip --rectarea --delay 5' 'Print'
rm -Rf gnome-keytool.py

# Adicionar chave SSH ao sistema e exibir na tela
sudo -u $SUDO_USER ssh-keygen -q -t rsa -N '' -f /home/$SUDO_USER/.ssh/id_rsa
clear
echo "Adicione a chave SSH abaixo no bitbucket, github, etc."
echo ""
cat /home/$SUDO_USER/.ssh/id_rsa.pub
echo ""
sudo -u $SUDO_USER xdg-open "https://bitbucket.org/account/settings/ssh-keys/"
echo "Quando estiver pronto, pressione qualquer tecla para continuar..."
while [ true ] ; do
read -t 3 -n 1
if [ $? = 0 ] ; then
exit ;
fi
done 

echo "Vamos agora configurar suas credenciais locais do git."
echo "Nome e sobrenome:"  
read nome  
echo "E-mail:"  
read email  
git config --global user.name "$nome"
git config --global user.email "$email"

# Aviso de reboot
clear
echo "Seu computador será reiniciado, pressione qualquer tecla para continuar."
while [ true ] ; do
read -t 3 -n 1
if [ $? = 0 ] ; then
exit ;
fi
done 

# Bye :)
reboot