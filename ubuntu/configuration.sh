#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Declarative configuration script ---------------------------------------------
# ------------------------------------------------------------------------------

# Setup package managers and installations -------------------------------------

apt_essentials=(
    curl
    wget
    git
    gpg
    ca-certificates
    software-properties-common
    apt-transport-https
    build-essential
)

custom_repositories=(
    vscode
    fastfetch
    tableplus
    docker
    brave-browser
    github-desktop
    mwt-desktop
)

apt_packages=(
    brave-browser
    code
    tableplus
    github-desktop
    alacritty
    stow
    fastfetch
    docker-ce
    gnome-sushi
    gnome-shell-extensions
    gnome-tweaks
    flameshot

    # Flameshot dependencies to OCR
    tesseract-ocr 
    tesseract-ocr-por 
    xclip 
    libnotify-bin
)

flatpak_packages=(
  com.mattjakeman.ExtensionManager
  com.belmoussaoui.Authenticator
  io.gitlab.adhami3310.Converter
)

brew_packages=(
  gcc
  lazydocker
)

flatpak_enabled=true
brew_enabled=true
docker_enabled=true

# Update the system ------------------------------------------------------------

echo "==> Updating the system..."
sudo apt update -y && sudo apt upgrade -y

# Install essential packages ---------------------------------------------------

echo "==> Installing essential packages..."
sudo apt install -y "${apt_essentials[@]}"
echo "==> Essential packages installation complete."

# Add custom repositories ------------------------------------------------------

for repo in "${custom_repositories[@]}"; do
    
    echo "-> Checking for $repo repository..."
    
    if ! ls /etc/apt/sources.list.d/*"$repo"* &>/dev/null \
       || ! grep -rq "$repo" /etc/apt/sources.list.d/; then
    
        echo "   $repo repository not found. Adding..."
        source ./repositories/$repo.sh
    
    else
    
        echo "   $repo repository already exists. Skipping..."
    
    fi

done

sudo apt update -y

echo "==> All custom repositories added."

# Install APT packages ---------------------------------------------------------

echo "==> Installing APT packages..."

for pkg in "${apt_packages[@]}"; do
    echo "-> Installing: $pkg"
    sudo apt-get install -y "$pkg"
done

echo "==> APT packages installation complete."

# Configure package managers ---------------------------------------------------

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

# Install Flatpak packages -----------------------------------------------------

if [ "$FLATPAK_ENABLED" = true ]; then
    echo "==> Installing Flatpak packages..."
    for pkg in "${flatpak_packages[@]}"; do
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
    for pkg in "${brew_packages[@]}"; do
        echo "-> Installing: $pkg"
        brew install "$pkg"
    done
    echo "==> Brew packages installation complete."
else
    echo "brew not enabled. skipping..."
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