#!/bin/bash

# Open terminal with Super+Return
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>Return']"

# Minimize window with Super+Apostrophe
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>apostrophe']"

# Lock screen with Super+L
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"

# Open Home Folder with Super+E
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
