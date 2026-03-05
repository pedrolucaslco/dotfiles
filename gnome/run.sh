#!/usr/bin/env bash

clear

# import functions
source "$(dirname "$0")/functions.sh"

# ------------------------------------------------------------------------------

pkg_manager=$(detect_package_manager)

if [ "$pkg_manager" = "none" ]; then
  echo "Gerenciador de pacotes não suportado."
  exit 1
fi

echo "Gerenciador detectado: $pkg_manager"

# update_system "$pkg_manager"
echo "Sistema atualizado com sucesso."

# Chamada da função
#install_packages "$pkg_manager"

# -------------------------------------------------------------------

# Setup custom keybindings
source "$(dirname "$0")/setup/keybindings.sh"
echo "GNOME keybindings configurados com sucesso."

# Setup workspaces
source "$(dirname "$0")/setup/workspaces.sh"
echo "Workspaces configurados com sucesso."

# Setup Gnome Software
source "$(dirname "$0")/setup/gnome-software.sh"
echo "Gnome Software desabilitado com sucesso."