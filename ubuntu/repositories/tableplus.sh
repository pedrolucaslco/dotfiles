#!/bin/bash

sudo add-apt-repository "deb [arch=amd64] https://deb.tableplus.com/debian/24 tableplus main"
wget -qO - https://deb.tableplus.com/apt.tableplus.com.gpg.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/tableplus-archive.gpg > /dev/null