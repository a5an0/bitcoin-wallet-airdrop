# Bitcoin Wallet Airdrop

You might want to go and give Bitcion to a bunch of people who have never had bitcoin, and do this distribution face-to-face. There are lots of scenarios where you might want to do this, for example distributing funds to victims of a natural disaster. Whatever the circumstance, this repo contains some tools to try to make that simple at scale. Onboarding a lot of people into Bitcoin quickly is tricky. This is just one idea on how to do it while reducing incremental work.

## Overview

Detailed instructions to follow, but at a high-level, the idea is that you run a script that generates `n` bitcoin wallets (where `n` is the number of people you want to give bitcoin to). The script will output two files: one is a "seed" file, the other is an "addresses" file.

The addresses file has a deposit address for each generated wallet. You use the wallet software of your choice to send bitcoin to each address in that file. I recommend doing this in batches as large as your software will allow to reduce fees and keep the process moving quickly.

The seed file has the bip39 mnemonic seed for each generated wallet, with one seed per page. You print that file out. You will end up with `n` "seed pages", where each page has a seed to a wallet that you deposited bitcoin on.

In the resources/ directory is a PDF file with detailed instructions on how to take a seed page, import it into bluewallet, and then sweep the funds to a new wallet (so that if you are bad and dont delete the seed file, then the recipient can't have their money stolen by you or someone who gets ahold of your computer or printer). The idea is you print out `n` copies of that PDF, and then put a copy of the directions and a seed page into `n` envelopes. You now basically have `n` little packets that each have a funded wallet seed and directions on how to import and sweep it. You can now go and hand those out to whomever, depending on your goals.

*Note: Right now there are only directions for bluewallet on ios. If you feel like writing up android directions, send me a PR.*

## Detailed setup instructions

### Required Dependencies
You will need a *nix machine with the following things installed;

- jq (https://stedolan.github.io/jq/)
- bdk-cli (https://github.com/bitcoindevkit/bdk-cli#install-bdk-cli)

### Generating the wallets and funding addresses

1. Check out this repo
2. From the root of the checked-out repo, run `bash generate_wallet.sh NUM_WALLETS` where NUM_WALLLETS is the number of wallets you want to generate. So for example, if you want to make 100 wallets, you sould do `bash generate_wallets.sh 100`
3. You will see the output telling you each one is done and then an informational message telling you where the files are. The seeds list will be in `output/seeds-[SOME RANDOM NUMBER].txt` and the addresses will be in `output/addresses-[THE SAME RANDOM NUMBER].txt` A number is added to the end of each file incase you want to run the tool more than once.
4. Using your bitcoin wallet software, send bitcoin to each address in the addresses file to fund all the wallets.
5. Print out the seeds file. It should print out one seed per page.
6. Print `n` copies of the directions PDF in the resources/ directory.
7. Get `n` envelopes and put a seed strip and a copy of the printed directions into each one. Seal them up
8. Delete the seeds and addresses files.
9. Go and hand out some bitcoin!

### Paper-saving tradeoff
On step (2) above, if you run `SAVE_PAPER=true bash generate_wallet.sh NUM_WALLETS`, it will put many seed phrases on a single page with dotted lined between them. You can cut along the dotted lines to get `n` seed strips, which can then be handed out. You will have more manual labor (cutting the strips out), but if you have a paper cutter, this might be worth the tradeoff to have fewer pages to print. Up to you!

### Some other things you may wish to do if you are so inclined, depending on usecase

- Run the generation script on a laptop booted into a live linux distro like tails
- Destroy the laptop and printer after you're done


## Other notes

You should only use this code to hand out bitcoin wallets in ways that are consistent with local laws and regulations.
