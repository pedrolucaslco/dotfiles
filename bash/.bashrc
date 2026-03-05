# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Migrated from Ubuntu's .bashrc file (see if there is another way in fedora later)
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable SSH key Bitbucket & GitHub
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/bitbucket
ssh-add ~/.ssh/id_ed25519

# Clear terminal input on launch
clear

# echo ''

# Run Fastfetch
#fastfetch -l small

#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    
# Launch Hubsy
# source ~/hubsy/bin/hubsy --debug

#. "$HOME/.cargo/env"

echo "SHORTCUTS --------------------------------------"
echo "h - for hubsy"
echo "refresh - for source ~/.bashrc"
#echo "lzd - lazydocker"
echo "gitsearch - search for commits on current folder"

echo "   "
echo "DEV WORKFLOW -----------------------------------"
echo "finder - for go to file and open into fresh"
echo "search [term] - for search some tem inside files"
echo "easy - cd into easyschool-laravel folder"

# opencode
#export PATH=/home/pedro/.opencode/bin:$PATH


# global functions
#search() {
#  grep -Ril "$1" .
#}
search() {
  [ -z "$1" ] && echo "Uso: search <termo>" && return 1

  grep -Ril "$1" . \
  | fzf --bind "enter:execute(fresh {+})"
}
