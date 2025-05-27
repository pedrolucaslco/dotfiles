# 💻 My Dotfiles with GNU Stow

This repository contains my personal configuration files (dotfiles) for Linux, organized in a modular way using [GNU Stow](https://www.gnu.org/software/stow/). This helps me maintain a consistent development environment across different machines.

---

## 🛠️ Available Packages
- Code - VS Code configuration

## 📦 Requirements

- [GNU Stow](https://www.gnu.org/software/stow/)

```bash
  sudo apt install stow  # Debian/Ubuntu
```

## 🗂️ Structure
Each folder in this repository represents a group of configurations and will be symlinked to $HOME using stow.

```
dotfiles/
├── Code/
│   └── ./.config/Code/User/settings.json
└── zsh/
    └── .zshrc

```

## ⚙️ How to Use
Clone this repository into your $HOME or wherever you prefer:

```
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Use stow to apply the desired package(s):

```
stow Code
stow zsh
```

This will create symbolic links in your home directory pointing to the files inside this repository.

To undo (unstow):

```
stow -D Code
```