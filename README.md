# Ivan On Tech - Chainlink 101 Lottery

> Note! This has recently been updated for the new Chainlink VRF API. `userProvidedSeed` is no longer needed. 

<br/>
<p align="center">
<a href="https://academy.ivanontech.com/" target="_blank">
<img src="https://kajabi-storefronts-production.kajabi-cdn.com/kajabi-storefronts-production/themes/1192645/settings_images/09PcimqsSdulelqfNUGE_IvanOnTech_Landscape.png" width="225" alt="Ivan On Tech Logo">
</a>
</p>
<br/>

## Requirements

- NPM
- Truffle
- truffle chainlink smartcontractkit/box

## Installation

1. Install dependencies by running:

```bash
npm install

# OR...

yarn install
```

## Deploy

For deploying to the kovan network, Truffle will use `truffle-hdwallet-provider` for your mnemonic and an RPC URL. Set your environment variables `$RPC_URL` and `$MNEMONIC` before running:

```bash
truffle migrate --network kovan --reset
```

## Test

```bash
truffle test 
```
