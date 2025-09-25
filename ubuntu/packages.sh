#!/bin/bash
# List of packages to be installed via apt and flatpak

APT_PACKAGES=(
  # Terminal tools
  stow
  build-essential
  fastfetch
  docker-ce

  # Apps
  alacritty
  tableplus
  github-desktop
  brave-browser

  # User Experience
  gnome-sushi
  gnome-shell-extensions
  gnome-tweaks
  flameshot

  # Docker dependences
  apt-transport-https 
  ca-certificates
  software-properties-common
)

FLATPAK_PACKAGES=(
  com.mattjakeman.ExtensionManager
  com.belmoussaoui.Authenticator
  app.zen_browser.zen
  io.gitlab.adhami3310.Converter
)

BREW_PACKAGES=(
  gcc
  lazydocker
)