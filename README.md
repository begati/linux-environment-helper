# Linux Environment Helper

Some scripts that helps me to get ready for work on a clean Linux installation.

# Debian (12 stable)

```bash
su -
usermod -aG sudo CHANGE_FOR_YOUR_USER
shutdown -r now

```
```bash
sudo bash <(wget -qO- https://raw.githubusercontent.com/begati/linux-environment-helper/main/debian-config.sh)
```

# Linux Mint - Infra (21.x)

```bash
curl -s https://raw.githubusercontent.com/begati/linux-environment-helper/main/mint-config-infra.sh | sudo bash
```

# Linux Mint - QA (21.x)

```bash
curl -s https://raw.githubusercontent.com/begati/linux-environment-helper/main/mint-config-qa.sh | sudo bash
```

# Linux Mint - Suporte (21.x)

```bash
curl -s https://raw.githubusercontent.com/begati/linux-environment-helper/main/mint-config-suporte.sh | sudo bash
```

# Pop!_OS (22.04 LTS)

```bash
curl -s https://raw.githubusercontent.com/begati/linux-environment-helper/main/popos-config.sh | sudo bash
```
 
# Fedora (> 34)

```bash
curl -s https://raw.githubusercontent.com/begati/linux-environment-helper/main/fedora-config.sh | sudo bash
```
