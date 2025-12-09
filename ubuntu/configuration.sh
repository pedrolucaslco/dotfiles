#!/usr/bin/env bash
# Declarative configuration script ---------------------------------------------

# Extra Package Managers
BREW_ENABLED=true
FLATPAK_ENABLED=true

# Custom Repositories
CUSTOM_REPOSITORIES=(
    fastfetch
    tableplus
    docker
    brave-browser
    github-desktop
    mwt-desktop
)

# List of packages to be installed
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
)

FLATPAK_PACKAGES=(
  com.mattjakeman.ExtensionManager
  com.belmoussaoui.Authenticator
  # app.zen_browser.zen
  io.gitlab.adhami3310.Converter
)

BREW_PACKAGES=(
  gcc
  lazydocker
)

# Update the system ------------------------------------------------------------

echo "==> Updating the system..."
sudo apt update -y && sudo apt upgrade -y

# Install essential packages ---------------------------------------------------

echo "==> Installing essential packages..."
sudo apt install -y curl wget git ca-certificates software-properties-common

# Configure package managers

if [ "$BREW_ENABLED" = true ]; then
    
    echo "==> Installing Brew..."

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo >> /home/pedro/.bashrc
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/pedro/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    echo "==> Brew installed."
fi

if [ "$FLATPAK_ENABLED" = true ]; then
    # Flatpak with Flathub
    echo "==> Installling Flatpak and configuring Flathub..."

    sudo apt install -y flatpak gnome-software-plugin-flatpak
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    
fi

# Add custom repositories ------------------------------------------------------

for repo in "${CUSTOM_REPOSITORIES[@]}"; do
    
    echo "-> Checking for $repo repository..."
    
    if ! ls /etc/apt/sources.list.d/*"$repo"* &>/dev/null \
       || ! grep -rq "$repo" /etc/apt/sources.list.d/; then
    
        echo "   $repo repository not found. Adding..."
    
        source ./repositories/$repo.sh
    
    else
    
        echo "   $repo repository already exists. Skipping..."
    
    fi

done

echo "==> All custom repositories added."

# Install APT packages ---------------------------------------------------------

echo "==> Installing APT packages..."

for pkg in "${APT_PACKAGES[@]}"; do
    echo "-> Installing: $pkg"
    sudo apt-get install -y "$pkg"
done

echo "==> APT packages installation complete."

# Install Flatpak packages -----------------------------------------------------

if [ "$FLATPAK_ENABLED" = true ]; then
    echo "==> Installing Flatpak packages..."
    for pkg in "${FLATPAK_PACKAGES[@]}"; do
        echo "-> Installing: $pkg"
        flatpak install flathub "$pkg"
    done
    echo "==> Flatpak packages installation complete."
else 
    echo "Flatpak not enabled. Skipping..."
fi

# Install Brew packages --------------------------------------------------------

if [ "$BREW_ENABLED" = true ]; then
    echo "==> Installing Brew packages..."
    for pkg in "${BREW_PACKAGES[@]}"; do
        echo "-> Installing: $pkg"
        brew install "$pkg"
    done
    echo "==> Brew packages installation complete."
else
    echo "Brew not enabled. Skipping..."
fi

# Setup Docker -----------------------------------------------------------------

if [ "$DOCKER_ENABLED" = true ]; then
    echo "==> Configuring Docker..."
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
    echo "==> Docker configuration complete."
fi

# Init Configurations
source ./my-defaults.sh