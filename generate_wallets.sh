#!/bin/bash

if [ "$#" -lt 1  ] || [ "$#" -gt 2 ]; then
    echo "You must enter at least 1 command line arguments: how many wallets to make"
    echo "If you also enter a second argument, of how much the total payout should be in sats, "
    echo "a sparrow-compatible CSV will be created to pay fund each wallet"
    exit
fi

NUM_WALLETS=$1
TOTAL_PAYOUT=$2
if [[ ${TOTAL_PAYOUT} ]]; then
  PER_ADDRESS_PAYOUT=$(($TOTAL_PAYOUT / $NUM_WALLETS))
fi

RUN=$$

mkdir build
cp -r resources/images build/
mkdir output
ADDRESS_FILE=output/addresses-$RUN.txt

WALLET=$PWD/bulkgeneratewallet-$RUN
bitcoin-cli createwallet $WALLET > /dev/null

for i in $(seq 1 $NUM_WALLETS)
do
    # Generate a new receiving address and get the private key
    ADDRESS=$(bitcoin-cli -rpcwallet=$WALLET getnewaddress)
    PRIVKEY=$(bitcoin-cli -rpcwallet=$WALLET dumpprivkey $ADDRESS)

    # Add address to the deposits file
    echo "$ADDRESS" >> $ADDRESS_FILE

    # Create a QR code for the privkey to import
    qrencode -o build/privkey-qr.png "bitcoin:$PRIVKEY"
    # put privkey into the template
    sed -e "s/INSERT_PRIVKEY_HERE/$PRIVKEY/" resources/directions.md > build/directions.md
    # put the run-i number on the privkey page to help keep track of packets
    sed -i.bak "s/<!-- ID FOR DISTRIBUTION -->/Packet Number: $RUN-$i/g" build/directions.md

    # render out directions for this wallet
    # The PDF renderer uses a headless chromium process to render markdown. Sometime that thing fails for whatever reason
    # So if it's not successful, we're just going to retry until it works
    while true; do
      mdpdf --format=Letter build/directions.md
      if [ $? -eq 0 ]; then
        break
      fi
      echo "retrying PDF render for number $i"
    done
    mv build/directions.pdf output/directions-$RUN-$i.pdf

    # Write the payout CSV if payout amount is provided
    if [[ ${PER_ADDRESS_PAYOUT} ]]; then
      echo "$ADDRESS, $PER_ADDRESS_PAYOUT, $RUN-$i" >> output/s2m-$RUN.csv
    fi
    # Cleanup
    rm build/privkey-qr.png
    rm build/directions.md
    echo "Done with number $i"
done

pdfunite output/directions-$RUN-* output/directions-all-$RUN.pdf

bitcoin-cli unloadwallet $WALLET > /dev/null
rm -rf $WALLET
rm -rf build

echo "One address per seed has been written to $ADDRESS_FILE. You can use whatever wallet software you chopose to fund these addresses."
echo "There is a set of PDF directions for each key in the output directory. A QR code for the private key is embedded in the PDF. Treat the file appropriately"
echo "A single PDF called output/directions-all-$RUN.pdf has been created that has all of them in one file, if you want to print them all in one shot."
if [[ ${PER_ADDRESS_PAYOUT} ]]; then
  echo "A csv file called output/s2m-$RUN.csv has been created that can be imported into Sparrow's Send-to-Many tool"
fi