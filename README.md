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
- mdpdf (https://github.com/BlueHatbRit/mdpdf)
- poppler (https://poppler.freedesktop.org)

If you are running Ubuntu (or an Ubuntu-compatible distro), there is a setup script that will install all the necessary dependencies for you.

### Generating the wallets and funding addresses

1. Check out this repo
2. If you are running ubuntu, you can do `sudo bash ubuntu_setup.sh` to download and install the dependencies. Then do `nohup bitcoind >/dev/null &` to start bitcoind in the background.
3. From the root of the checked-out repo, run `bash generate_wallet.sh NUM_WALLETS` where NUM_WALLLETS is the number of wallets you want to generate. So for example, if you want to make 100 wallets, you should do `bash generate_wallets.sh 100`
4. You will see the output telling you each one is done and then an informational message telling you where the files are. The addresses will be in `output/addresses-[RANDOM NUMBER].txt` A number is added to the end of each file incase you want to run the tool more than once. In the outputs directory there will also be a series of PDFs named `directions-[THE SAME RANDOM NUMBER]-[INDEX].pdf` where INDEX is 1-`n`. In other words, there is one PDF for each address.
5. Using your bitcoin wallet software, send bitcoin to each address in the addresses file to fund all the wallets.
6. Print out each PDF `directions` file. The setup script automatically disables device networking so the printer will need a hard wired connection. Alternatively, there is an "all copies" PDF that gets created that has all of the directions documents in one file, so you can print them all in one shot.
7. Get `n` envelopes and put a directions printout in each one.
8. Delete everything in `output`.
9. Go and hand out some bitcoin!


### Funding all of the wallets using "Send to Many" from Sparrow Wallet

Sparrow wallet has a "Send to Many" feature that can import a CSV of `address, amount, label` and set up a large many-output transaction. This means that you can take the address-file that you generated, and fund the addresses in batches rather than one at a time.

When you run `generate_wallets.sh`, just pass it a second parameter with the **total** amount that you want to pay out across all the wallets **in sats**. The script will divide that number by the number of wallets (it's integer math, so doesn't handle remainders) and then will export a CSV file in  the output directory with a line for each address, the payout amount, and the ID number of the address (which matches an ID put into the directions).

Then, in Sparrow Wallet, click `Tools -> Send to Many`. It will open a window with an empty table in it. Click the `Import CSV` file and navigate to the `output/s2m.csv` file. Sparrow will create a transaction for you that spends $AMOUNT to each address in the csv file. Now you can proceed to sign the transaction as you normally would (using whatever combination of online and offline signers you have for that wallet) and broadcast the transaction.

Sparrow is great because it has good support for multisig, good support for many signing devices, good support for using your own bitcoin node (through RPC or a private electrum server), and has an easy-to-use send-to-many feature. At some point I might write up directions for other software. If you write up directions, feel free to send a Pull Request!

### Some other things you may wish to do if you are so inclined, depending on usecase

- Run the generation script on a laptop booted into a live linux distro like tails
- Destroy the laptop and printer after you're done


## Other notes

You should only use this code to hand out bitcoin wallets in ways that are consistent with local laws and regulations.

## Other things that should be added

*If any of this sounds interesting to you, PR's welcome!*

- Add some "you have bitcoin. now what?" documentation

## Frequently Asked Questions

#### Why hand out something physical? Why not just have everyone install a bitcoin wallet and then just do an on-chain transfer on the spot?
A couple of reasons: 
1. It allows you to parallelize the whole process and make it asynchronous. If you have volunteers/aid workers have to 
walk every recipient through downloading and installing a wallet, setting it up, and then doing an onchain transfer, it means
that your distribution is rate-limited by the rate at which individual workers can go through that process. If instead, you
give people really detailed instructions that they can follow themselves at their own pace and then provide 1:1 help with people
who get stuck, then you can distribute funds to more people faster with fewer workers. 
2. Related to (1): In my experience, aid distribution usually ends up happening in one of two ways: you send workers "door-to-door" through a community,
or you have a centralized distribution center (either a kitchen or something that looks like a food bank). In those scenarios, I think being able to hand someone
a thing to take with them (in the supply-pickup scenario) or keep when you leave (in the door-to-door) scenario is going to be more effective than asking people
to wait in line for someone to get them bitcoin. Instead, someone can take directions and a privkey with them, set it up, and come back if they need help with it.
3. Provides a mechanism to break the distribution pot into pre-defined denominations and then have non-technical aid workers distribute them in managed ways. 
It's very simple (for example) to tell a volunteer working at a food bank "give one of these to each family who comes in, limit one per family". Also makes it easy to 
control how many wallets each worker has access to and handle things like replenishment without actual onchain shuffles of funds. 

#### Yeah, ok. But wouldn't it just be easier to hand out flyers telling people to install some bitcoin app and then if they do it, come in and quickly get funds?
Maybe! So far this repo is mostly text, some screen shots, and ~50 lines of shell :)
I'm also exploring things like Hexawallet gift codes, lnurl-w and/or bolt12 offers, and other options. 
If you have ideas for better methods, feel free to cut an issue or submit a PR, would love to hear your perspective! 