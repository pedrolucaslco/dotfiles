#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Setup custom keybindings
# ------------------------------------------------------------------------------

# Change default keybindings ----------------------------------------------------

gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>apostrophe']"
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]"
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
gsettings set org.gnome.desktop.wm.keybindings switch-group "[]"
gsettings set org.gnome.mutter.wayland.keybindings restore-shortcuts "[]"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift><Super>S']"

gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"


gsettings set org.gnome.shell.keybindings switch-to-application-1 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-9 "[]"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']"

gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>7']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>8']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 "['<Super><Shift>9']"

gsettings set org.freedesktop.ibus.panel.emoji hotkey "[]"

# Reset custom keybindings -----------------------------------------------------

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[]"

BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
for i in {0..20}; do
  gsettings reset-recursively "$BASE/custom$i" 2>/dev/null
done

# Add new keybinding -----------------------------------------------------------

add_keybinding() {
  BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

  CURRENT=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | tr -d '\n')
  USED=$(echo "$CURRENT" | grep -o 'custom[0-9]\+' | sed 's/custom//')

  i=0
  while echo "$USED" | grep -qx "$i"; do
    i=$((i + 1))
  done

  SLOT="$BASE/custom$i/"

  if [[ "$CURRENT" == "[]" || "$CURRENT" == "@as []" ]]; then
    NEW_LIST="['$SLOT']"
  else
    NEW_LIST="${CURRENT%]}",\ "'$SLOT']"
  fi

  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_LIST"

  echo "$SLOT"
}

# Alacritty keybinding (Super + Enter)
SLOT=$(add_keybinding)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$SLOT name 'Alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$SLOT command 'alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$SLOT binding '<Super>Return'

# Gradia keybinding (Super + Shift + S)
#SLOT=$(add_keybinding)
#gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$SLOT name 'Gradia Screenshot'
#gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$SLOT command 'flatpak run be.alexandervanhee.gradia --screenshot=INTERACTIVE'
#gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$SLOT binding '<Super><Shift>S'

echo "Keybindings configured successfully."