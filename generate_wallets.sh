#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "You must enter exactly 1 command line arguments: how many wallets to make"
    exit
fi

NUM_WALLETS=$1
RUN=$$

mkdir output
SEED_FILE=output/seeds-$RUN.txt
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
    qrencode -o output/$RUN-$i.png "bitcoin:$PRIVKEY"

    echo "Done with number $i"
done

echo "All done! You should now print out the $SEED_FILE file, cut along each dotted line and you will end up with $NUM_WALLETS seeds that you can hand out"
echo "One address per seed has been written to $ADDRESS_FILE. You can use whatever wallet software you chopose to fund these addresses."
