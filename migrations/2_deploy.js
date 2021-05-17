const Lottery = artifacts.require('Lottery')
const {LinkToken} = require('@chainlink/contracts/truffle/v0.4/LinkToken');

module.exports = async (deployer, network, [defaultAccount]) => {
  if(!network.startsWith('kovan')){
    console.log('Currently only works with Kovan!')
    LinkToken.setProvider(deployer.provider)
  }else{
    const KOVAN_KEYHASH = '0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4'
    const KOVAN_VRF_COORDINATOR = '0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9'
    const ETH_USD_PRICE_FEED = '0x9326BFA02ADD2366b30bacB125260Af641031331'
    const KOVAN_LINK_TOKEN = '0xa36085F69e2889c224210F603D836748e7dC0088'
    deployer.deploy(Lottery, ETH_USD_PRICE_FEED, KOVAN_VRF_COORDINATOR, KOVAN_LINK_TOKEN, KOVAN_KEYHASH)

  }
}
