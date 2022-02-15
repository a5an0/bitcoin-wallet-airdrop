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

for i in $(seq 0 $NUM_WALLETS)
do
    # Generate a new seed phease and xpriv
    seed=$(bdk-cli -n bitcoin key generate)
    mnemonic=$(echo $seed | jq -r .mnemonic)
    xprv=$(echo $seed | jq -r .xprv)

    # create a new wallet and get an address
    derived_xprv=$(bdk-cli -n bitcoin key derive -x $xprv --path "m/84'/0'/0'/0" | jq -r .xprv)
    descriptor="wpkh($derived_xprv)"
    bdk-cli -n bitcoin wallet -w autogen-$RUN-$i --descriptor $descriptor sync > /dev/null
    ADDRESS=$(bdk-cli -n bitcoin wallet -w autogen-$RUN-$i --descriptor $descriptor get_new_address | jq -r .address)

    # add seed and address to the output lists
    echo "Wallet Seed" >> $SEED_FILE
    echo $mnemonic >> $SEED_FILE
    echo "==========================================================" >> $SEED_FILE
    echo "$ADDRESS" >> $ADDRESS_FILE

    echo "Done with number $i"
done

echo "All done! You should now print out the $SEED_FILE file, cut along each dotted line and you will end up with $NUM_WALLETS seeds that you can hand out"
echo "One address per seed has been written to $ADDRESS_FILE. You can use whatever wallet software you chopose to fund these addresses."
