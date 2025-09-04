#!/bin/bash
# Configure package managers

# Flatpak with Flathub
echo "==> Instalando Flatpak e configurando Flathub..."

sudo apt install -y flatpak gnome-software-plugin-flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Brew (Linuxbrew)
echo "==> Instalando Brew..."

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >> /home/pedro/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/pedro/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "==> Concluído."