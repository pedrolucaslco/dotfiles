
sudo apt install apache2

sudo usermod -aG www-data $USER

sudo chgrp -R www-data ~/development/easyschool-app

sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php7.4 php7.4-cli php7.4-common php7.4-mysql php7.4-xml php7.4-mbstring php7.4-curl php7.4-zip
