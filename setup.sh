#!/bin/bash

apt update

apt install -y wget qrencode gpg npm

npm install -g markdown-pdf --ignore-scripts

wget https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0-x86_64-linux-gnu.tar.gz
tar xvzf bitcoin-22.0-x86_64-linux-gnu.tar.gz
chmod +x bitcoin-22.0/bin/*
mv bitcoin-22.0/bin/{bitcoind,bitcoin-cli} /usr/local/bin/

rm -rf bitcoin-22.0*