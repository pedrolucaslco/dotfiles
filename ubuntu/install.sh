#!/bin/bash

# Steps:
# 1. Setup repositories
# 2. Configure package managers (apt, flatpak, brew)
# 3. Install packages

# Prep environment
sudo apt install -y curl wget git

# Source other scripts
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




# Set Alacritty as default Terminal Emulator
gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''


# CUSTOM KEYBINDINGS ----------------------------

# Define os slots custom0..custom9
BASE_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
KEYBINDINGS=()

for i in $(seq 0 9); do
    KEYBINDINGS+=("$BASE_PATH/custom$i/")
done


# Converte o array em formato aceito pelo gsettings
KEYBINDINGS_STR="["
for k in "${KEYBINDINGS[@]}"; do
    KEYBINDINGS_STR+="'$k', "
done
KEYBINDINGS_STR="${KEYBINDINGS_STR%, }]" # remove última vírgula


# Registra os 10 slots
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$KEYBINDINGS_STR"

# Inicializa com valores vazios
for i in $(seq 0 9); do
    PREFIX="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom$i/"
    gsettings set $PREFIX name "empty"
    gsettings set $PREFIX command "true"
    gsettings set $PREFIX binding ""
done

echo "Foram criados 10 slots (custom0 a custom9). Agora é só editar com:"
echo "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom0/ name 'Meu Atalho'"
echo "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom0/ command 'meu-comando'"
echo "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom0/ binding '<Super><Shift>S'"

# END CUSTOM KEYBINDINGS ----------------------------

# Set flameshot (with the sh fix for starting under Wayland) on alternate print screen key

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom1/ name 'Flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom1/ command 'sh -c -- "flameshot gui"'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom1/ binding '<Super><Shift>S'

# Slot custom0
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom0/ name 'Lazydocker'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom0/ command 'x-terminal-emulator -e lazydocker'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom0/ binding '<Super><Shift>D'

# -----------------
# WORKSPACES
# --------------------

# Primeiro: fixa 10 workspaces
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 10

# Limpa os atalhos da dock (Super+1..9 e Super+0)
for i in {1..9}; do
  gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
done

# Define atalhos para navegar (Super+N) e mover janelas (Super+Shift+N)
for i in {1..9}; do
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"
done

# Workspace 10 (Super+0)
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"

# Center new windows
gsettings set org.gnome.mutter center-new-windows true
