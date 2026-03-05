#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Disable Gnome Software in background
# ------------------------------------------------------------------------------

gsettings set org.gnome.software download-updates false

systemctl --user mask gnome-software.service
systemctl --user mask gnome-software-refresh.service

# systemctl --user unmask gnome-software.service
# systemctl --user unmask gnome-software-refresh.service

echo "Gnome Software disabled successfully."