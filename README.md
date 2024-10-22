# Linux Environment Helper

Some scripts that helps me to get ready for work on a clean Linux installation.

# Fedora 41

```bash
curl -s https://raw.githubusercontent.com/begati/linux-environment-helper/main/fedora-config.sh | sudo bash
```

# Debian 12

```bash
su -
usermod -aG sudo CHANGE_FOR_YOUR_USER
apt update; apt install curl -y
shutdown -r now

```
```bash
curl -s https://raw.githubusercontent.com/begati/linux-environment-helper/main/debian-config.sh | sudo bash

```

# Linux Mint - Infra (22.x)

```bash
curl -s https://raw.githubusercontent.com/begati/linux-environment-helper/main/mint-config-infra.sh | sudo bash
```

# Linux Mint - QA (22.x)

```bash
curl -s https://raw.githubusercontent.com/begati/linux-environment-helper/main/mint-config-qa.sh | sudo bash
```

# Linux Mint - Suporte (22.x)

```bash
curl -s https://raw.githubusercontent.com/begati/linux-environment-helper/main/mint-config-suporte.sh | sudo bash
```

# Pop!_OS (22.04 LTS)

```bash
curl -s https://raw.githubusercontent.com/begati/linux-environment-helper/main/popos-config.sh | sudo bash
```
