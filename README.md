# Bitcoin Wallet Airdrop

You might want to go and give Bitcion to a bunch of people who have never had bitcoin, and do this distribution face-to-face. There are lots of (for example, humanitarian) scenarios where you might want to do this. Whatever the circumstance, this repo contains some tools to try to make that simple at scale. Onboarding a lot of people into Bitcoin quickly is tricky. This is just one idea on how to do it while reducing incremental work.

## Overview

Detailed instructions to follow, but at a high-level, the idea is that you run a script that generates `n` bitcoin wallets (where `n` is the number of people you want to give bitcoin to). The script will output two files: one is a "seed" file, the other is an "addresses" file.

The addresses file has a deposit address for each generated wallet. You use the wallet software of your choice to send bitcoin to each address in that file. I recommend doing this in batches as large as your software will allow to reduce fees and keep the process moving quickly.

The seed file has the bip39 mnemonic seed for each generated wallet, with a dotted line delimeter between each one. You print that file out and then cut along the dotted lines. You will end up with `n` "seed strips", where each strip has a seed to a wallet that you deposited bitcoin on.

In the resources/ directory is a PDF file with detailed instructions on how to take a seed strip, import it inot bluewallet, and then sweep the funds to a new wallet (so that if you are bad and dont delete the seed file, then the recipient can't have their money stolen by you or someone who gets ahold of your computer or printer). The idea is you print out `n` copies of that PDF, and then put a copy of the directions and a seed strip into `n` envelopes. You now basically have `n` little packets that each have a funded wallet seed and directions on how to import and sweep it. You can now go and hand those out to whomever, depending on your goals.

*Note: Right now there are only directions for bluewallet on ios. If you feel like writing up android directions, send me a PR.*
