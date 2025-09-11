#!/bin/bash

# Setup requirements for add new repositories
sudo apt install -y curl wget git ca-certificates

source ./repositories.sh
source ./packages.sh

echo "==> Atualizando repositórios..."

sudo apt update -y

echo "==> Instalando pacotes APT..."

for pkg in "${APT_PACKAGES[@]}"; do
    echo "-> Instalando: $pkg"
    sudo apt-get install -y "$pkg"
done

echo "==> Concluído."

echo "==> Instalando pacotes Flatpak..."

for pkg in "${FLATPAK_PACKAGES[@]}"; do
    echo "-> Instalando: $pkg"
    flatpak install flathub "$pkg"
done

echo "==> Concluído."

echo "==> Instalando pacotes Brew..."

for pkg in "${BREW_PACKAGES[@]}"; do
    echo "-> Instalando: $pkg"
    brew install "$pkg"
done

echo "==> Concluído."

echo "==> Configurando Docker..."
sudo systemctl start docker
sudo systemctl enable docker

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker


# Init Configurations
source ./config.sh