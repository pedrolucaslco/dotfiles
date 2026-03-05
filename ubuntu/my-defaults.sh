#!/usr/bin/env bash
# set -e

# Packages
packages=(
  # flameshot dependencies
  xdg-desktop-portal 
  xdg-desktop-portal-gnome
)

flatpaks=(
  be.alexandervanhee.gradia
)

# Configure keybindings --------------------------------------------------------

#!/bin/bash

BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

get_next_slot() {
  CURRENT=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
  USED=$(echo "$CURRENT" | grep -o 'custom[0-9]\+' | sed 's/custom//')

  i=0
  while echo "$USED" | grep -qx "$i"; do
    i=$((i + 1))
  done

  SLOT="$BASE/custom$i/"

  if [[ "$CURRENT" == "@as []" ]]; then
    NEW_LIST="['$SLOT']"
  else
    NEW_LIST=$(echo "$CURRENT" | sed "s/]$/, '$SLOT']/")
  fi

  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_LIST"
  echo "$SLOT"
}

# -------------------------------------------------------------------
# Set Alacritty as default terminal
gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''

# -------------------------------------------------------------------
# Alacritty keybinding (Super + Enter)
ALACRITTY_KEYBIND_SLOT=$(get_next_slot)

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$ALACRITTY_KEYBIND_SLOT name 'Alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$ALACRITTY_KEYBIND_SLOT command 'alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$ALACRITTY_KEYBIND_SLOT binding '<Super>Return'

# -------------------------------------------------------------------
# Gradia keybinding (Super + Shift + S)
GRADIA_KEYBIND_SLOT=$(get_next_slot)

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$GRADIA_KEYBIND_SLOT name 'Gradia Screenshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$GRADIA_KEYBIND_SLOT command \
'flatpak run be.alexandervanhee.gradia --screenshot=INTERACTIVE'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$GRADIA_KEYBIND_SLOT binding '<Super><Shift>S'





















echo "Generating custom-keybinding slots custom1 to custom9..."

SLOTS=()

for i in {1..9}; do
  SLOTS+=("/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$i/")
done

SLOTS_GSETTINGS=$(printf "'%s'," "${SLOTS[@]}")
SLOTS_GSETTINGS="[${SLOTS_GSETTINGS%,}]"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$SLOTS_GSETTINGS"
echo "done."



# Configure Alacritty ----------------------------------------------------------

# Set Alacritty as default terminal

gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''

# Set keyboard shortcut Super + Enter for Alacritty

ALACRITTY_KEYBIND_SLOT="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$ALACRITTY_KEYBIND_SLOT name 'Alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$ALACRITTY_KEYBIND_SLOT command 'alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$ALACRITTY_KEYBIND_SLOT binding '<Super>Return'

# Configure Gradia for screenshots ---------------------------------------------

GRADIA_KEYBIND_SLOT="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$GRADIA_KEYBIND_SLOT name 'Gradia Screenshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$GRADIA_KEYBIND_SLOT command 'flatpak run be.alexandervanhee.gradia --screenshot=INTERACTIVE'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$GRADIA_KEYBIND_SLOT binding '<Super><Shift>S'


# ------------------------------------------------------------------------------
# Workspaces -------------------------------------------------------------------
# gsettings set org.gnome.mutter dynamic-workspaces false
# gsettings set org.gnome.desktop.wm.preferences num-workspaces 10
# gsettings set org.gnome.mutter auto-maximize false

# Clear Ubuntu Dock shortcuts (Super+1..9)
# for i in {1..9}; do
#   gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
# done

# Workspace 10
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"
# gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"

# Workspace 1..9
# for i in {1..9}; do
#   gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
#   gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"
# done

# ------------------------------------------------------------------------------
# Optional: disable ibus emoji shortcut -----------------------------------------
# gsettings set org.freedesktop.ibus.panel.emoji hotkey "[]"

# echo "GNOME keybindings configurados com sucesso."
