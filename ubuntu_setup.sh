#!/bin/bash

sudo apt update

sudo apt install -y wget qrencode gpg npm poppler-utils

# install all the dependencies we'll need for chromium (for pdf rendering)
sudo apt install -y gconf-service libgbm-dev libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget
# install pdf rendering package
sudo npm install -g mdpdf --unsafe-perm=true -allow-root

# get necessary bitcoin-core components. TODO: check sigs on download
wget https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0-x86_64-linux-gnu.tar.gz
tar xvzf bitcoin-22.0-x86_64-linux-gnu.tar.gz
chmod +x bitcoin-22.0/bin/*
sudo mv bitcoin-22.0/bin/{bitcoind,bitcoin-cli} /usr/local/bin/

rm -rf bitcoin-22.0*