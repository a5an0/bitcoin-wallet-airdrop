#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "You must enter exactly 1 command line arguments: how many wallets to make"
    exit
fi

NUM_WALLETS=$1
RUN=$$

mkdir output
ADDRESS_FILE=output/addresses-$RUN.txt

WALLET=bulkgeneratewallet-$RUN
bitcoin-cli createwallet $WALLET

for i in $(seq 1 $NUM_WALLETS)
do
    # Generate a new receiving address and get the private key
    ADDRESS=$(bitcoin-cli -rpcwallet=$WALLET getnewaddress)
    PRIVKEY=$(bitcoin-cli -rpcwallet=$WALLET dumpprivkey $ADDRESS)

    # Add address to the deposits file
    echo "$ADDRESS" >> $ADDRESS_FILE

    # Create a QR code for the privkey to import
    qrencode -o output/privkey-qr.png "bitcoin:$PRIVKEY"
    # render out directions for this wallet
    markdown-pdf -f Letter -o output/directions-$RUN-$i.pdf -c resources resources/directions.md

    echo "Done with number $i"
done

echo "One address per seed has been written to $ADDRESS_FILE. You can use whatever wallet software you chopose to fund these addresses."
echo "There is a set of PDF directions for each key in the output directory. A QR code for the private key is embedded in the PDF. Treat the file appropriately"