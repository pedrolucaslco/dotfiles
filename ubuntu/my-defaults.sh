#!/bin/bash

# ------------------------------------------------------------------------------
# Set Alacritty as default Terminal Emulator -----------------------------------

gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''

# ------------------------------------------------------------------------------
# Generate custom keybindings slots --------------------------------------------

BASE_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

KEYBINDINGS=()

for i in $(seq 0 9); do
    KEYBINDINGS+=("$BASE_PATH/custom$i/")
done

KEYBINDINGS_STR="["

for k in "${KEYBINDINGS[@]}"; do
    KEYBINDINGS_STR+="'$k', "
done

KEYBINDINGS_STR="${KEYBINDINGS_STR%, }]" # remove last comma

# Register 10 slots for keybindings
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$KEYBINDINGS_STR"

# Initialize with empty values
for i in $(seq 0 9); do
    PREFIX="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom$i/"
    gsettings set $PREFIX name "empty"
    gsettings set $PREFIX command "true"
    gsettings set $PREFIX binding ""
done

echo "Has been created slots (custom0 a custom9). To edit use:"
echo "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom0/ name 'Meu Atalho'"
echo "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom0/ command 'meu-comando'"
echo "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom0/ binding '<Super><Shift>S'"


# ------------------------------------------------------------------------------
# Set flameshot (with the sh fix for starting under Wayland) on alternate print screen key

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom2/ name 'Flameshot OCR'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom2/ command 'sh -c -- "flameshot gui --raw -p Imagens/ | tesseract stdin stdout -l por | xclip -selection clipboard && notify-send 'OCR' 'Texto copiado para o clipboard'"'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom2/ binding '<Super><Shift>S'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom1/ name 'Flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom1/ command 'sh -c -- "flameshot gui"'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE_PATH/custom1/ binding '<Super><Shift>S'

# ------------------------------------------------------------------------------
# Workspaces -------------------------------------------------------------------

# Fix 10 Workspaces
#gsettings set org.gnome.mutter dynamic-workspaces false
#gsettings set org.gnome.desktop.wm.preferences num-workspaces 10
#gsettings set org.gnome.mutter auto-maximize false

# Clear Ubuntu dock shortcuts (Super+1..9 e Super+0)
#for i in {1..9}; do
#  gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
#done

# Workspace 10 (Super+0)
#gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"
#gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"

# Define atalhos para navegar (Super+N) e mover janelas (Super+Shift+N)
#for i in {1..9}; do
#  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
#  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"
#done

# ------------------------------------------------------------------------------
# Windows Behavior ---------------------------------------------------------------
# Center new windows
gsettings set org.gnome.mutter center-new-windows true

# ------------------------------------------------------------------------------
# OPTIONAL ---------------------------------------------------------------------

# Disable default emoji panel from ibus to use gnome Extensions Emojy  Copy

# Check if is correctly set
#gsettings get org.freedesktop.ibus.panel.emoji hotkey

# Clear hotkey
#gsettings set org.freedesktop.ibus.panel.emoji hotkey "[]"

# To restore
# gsettings set org.freedesktop.ibus.panel.emoji hotkey "['<Super>period', '<Super>semicolon']"