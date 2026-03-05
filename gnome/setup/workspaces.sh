#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Setup Gnome workspaces
# ------------------------------------------------------------------------------

gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 10
gsettings set org.gnome.mutter auto-maximize false