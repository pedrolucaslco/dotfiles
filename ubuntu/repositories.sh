#!/bin/bash

APP_REPOSITORIES=(
    # add hashtag to dismiss a repository from being added
    fastfetch
    tableplus
    docker
    brave-browser

    # github-desktop
    mwt-desktop
)

#make a foreach loop to add all repositories, if exists on variable, switch case to add each one
for repo in "${APP_REPOSITORIES[@]}"; do
    echo "-> Checking for $repo repository..."
    
    if ! ls /etc/apt/sources.list.d/*"$repo"* &>/dev/null \
       || ! grep -rq "$repo" /etc/apt/sources.list.d/; then
        echo "   $repo repository not found. Adding..."
        source ./repositories/$repo.sh
    else
        echo "   $repo repository already exists. Skipping..."
    fi
done

echo "==> All configured repositories added."