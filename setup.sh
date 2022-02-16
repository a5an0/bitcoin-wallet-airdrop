#!/bin/bash

echo "Installing wget, qrencode, gpg, and npm"
apt install -y wget qrencode gpg npm

echo "installing markdown-pdf"
npm install -g markdown-pdf

wget https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0-x86_64-linux-gnu.tar.gz
tar xvzf bitcoin-22.0-x86_64-linux-gnu.tar.gz
chmod +x bitcoin-22.0/bin/*
mv bitcoin-22.0/bin/{bitcoind,bitcoin-cli} /usr/local/bin/

