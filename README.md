# Bitcoin Wallet Airdrop

You might want to go and give Bitcion to a bunch of people who have never had bitcoin, and do this distribution face-to-face. There are lots of scenarios where you might want to do this, for example distributing funds to victims of a natural disaster. Whatever the circumstance, this repo contains some tools to try to make that simple at scale. Onboarding a lot of people into Bitcoin quickly is tricky. This is just one idea on how to do it while reducing incremental work.

## Overview

Detailed instructions to follow, but at a high-level, the idea is that you run a script that generates `n` bitcoin addresses (where `n` is the number of people you want to give bitcoin to). The script will output an "addresses file", with a deposit address for each wallet, and then `n` instructions PDFs that contain a QR-encoded private key and instructions on how to import it into bluewallet.

You use the wallet software of your choice to send bitcoin to each address in the addresses file. I recommend doing this in batches as large as your software will allow to reduce fees and keep the process moving quickly.

Each directions PDF has detailed step-by-step instructions (with screenshots!) on how to import the private key into bluewallet and how to sweep the funds into a new wallet. You print out each one of these, put each in a sealed envelope, and then go hand out bitcoin!

*Note: Right now there are only directions for bluewallet on ios. If you feel like writing up android directions, send me a PR.*

## Detailed setup instructions

### Required Dependencies
You will need a *nix machine with the following things installed;

- bitcoin-core (doesn't have to be synced, just bitcoin-cli needs to work)
- qrencode
- markdown-pdf (https://www.npmjs.com/package/markdown-pdf)

### Generating the wallets and funding addresses

1. Check out this repo
2. From the root of the checked-out repo, run `bash generate_wallet.sh NUM_WALLETS` where NUM_WALLLETS is the number of wallets you want to generate. So for example, if you want to make 100 wallets, you should do `bash generate_wallets.sh 100`
3. You will see the output telling you each one is done and then an informational message telling you where the files are. The addresses will be in `output/addresses-[RANDOM NUMBER].txt` A number is added to the end of each file incase you want to run the tool more than once. In the outputs directory there will also be a series of PDFs named `directions-[THE SAME RANDOM NUMBER]-[INDEX].pdf` where INDEX is 1-`n`. In other words, there is one PDF for each address.
4. Using your bitcoin wallet software, send bitcoin to each address in the addresses file to fund all the wallets.
5. Print out each PDF `directions` file.
6. Get `n` envelopes and put a directions printout in each one.
8. Delete everything in `output`.
9. Go and hand out some bitcoin!

### Funding all of the wallets using "Send to Many" from Sparrow Wallet

Sparrow wallet has a "Send to Many" feature that can import a CSV of `address, amount, label` and set up a large many-output transaction. This means that you can take the address-file that you generated, and fund the addresses in batches rather than one at a time.

Assuming that the address file is called `output/addresses-1234.txt` the amount you want each recipient to get (IN SATS) is $AMOUNT, and a label for each is $MESSAGE, do:

``` shell
for i in $(cat output/addresses-1234.txt); do echo "$i, $AMOUNT, $MESSAGE" >> output/s2m.csv; done
```

Then, in Sparrow Wallet, click `Tools -> Send to Many`. It will open a window with an empty table in it. Click the `Import CSV` file and navigate to the `output/s2m.csv` file. Sparrow will create a transaction for you that spends $AMOUNT to each address in the csv file. Now you can proceed to sign the transaction as you normally would (using whatever combination of online and offline signers you have for that wallet) and broadcast the transaction.

Sparrow is great because it has good support for multisig, good support for many signing devices, good support for using your own bitcoin node (through RPC or a private electrum server), and has an easy-to-use send-to-many feature. At some point I might write up directions for other software. If you write up directions, feel free to send a Pull Request!

### Some other things you may wish to do if you are so inclined, depending on usecase

- Run the generation script on a laptop booted into a live linux distro like tails
- Destroy the laptop and printer after you're done


## Other notes

You should only use this code to hand out bitcoin wallets in ways that are consistent with local laws and regulations.


## TODOs
- delete the bitcoin-core wallet that's used to generate addresses
