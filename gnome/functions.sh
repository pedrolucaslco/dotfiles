#!/usr/bin/env bash

# Função para detectar gerenciador de pacotes
detect_package_manager() {
  if command -v apt >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  else
    echo "none"
  fi
}

# Função para atualizar sistema
update_system() {
  local pm="$1"
  echo "Atualizando sistema..."
  
  case "$pm" in
    apt)
      sudo apt update
      sudo apt upgrade -y
      ;;
    dnf)
      sudo dnf upgrade --refresh -y
      ;;
    pacman)
      sudo pacman -Syu --noconfirm
      ;;
  esac
}

# Lista de pacotes para instalar (edite esta variável)
PACKAGES=(
  "git"
  "vim"
  "curl"
  "wget"
  "tree"
  "htop"
)

# Função para instalar pacotes
install_packages() {
  local pm="$1"
  echo "Instalando pacotes..."
  
  local success=()
  local failed=()
  
  for package in "${PACKAGES[@]}"; do
    echo "Instalando $package..."
    
    case "$pm" in
      apt)
        if sudo apt install -y "$package" 2>/dev/null; then
          success+=("$package")
        else
          failed+=("$package")
        fi
        ;;
      dnf)
        if sudo dnf install -y "$package" 2>/dev/null; then
          success+=("$package")
        else
          failed+=("$package")
        fi
        ;;
      pacman)
        if sudo pacman -S --noconfirm "$package" 2>/dev/null; then
          success+=("$package")
        else
          failed+=("$package")
        fi
        ;;
    esac
  done
  
  echo
  echo "=== Resumo da instalação ==="
  if [ ${#success[@]} -gt 0 ]; then
    echo "✓ Pacotes instalados com sucesso:"
    printf "  %s\n" "${success[@]}"
  fi
  
  if [ ${#failed[@]} -gt 0 ]; then
    echo "✗ Pacotes com erro na instalação:"
    printf "  %s\n" "${failed[@]}"
  fi
}