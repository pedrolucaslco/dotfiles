# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
. "$HOME/.cargo/env"


# PEDRO CONFIGS -----------------------------------------------------------

# Start ssh-agent with fixed socket (Wayland/sway compatible)
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -a "$XDG_RUNTIME_DIR/ssh-agent.socket" > /dev/null
fi

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Adiciona as chaves
[[ -f ~/.ssh/id_ed25519 ]] && ssh-add -q ~/.ssh/id_ed25519 2>/dev/null
[[ -f ~/.ssh/bitbucket ]] && ssh-add -q ~/.ssh/bitbucket 2>/dev/null
