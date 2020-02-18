/* eslint-env node */
/* global artifacts */
//const DummyToken = artifacts.require('test/DummyToken');
//const TOS=artifacts.require('TOS.sol')



const NFT=artifacts.require('testNFT');
const TokenProxy=artifacts.require('NFTlottery')
function deployContracts(deployer, network) {

  deployer.then(async () => {
    
   // await deployer.deploy(PO)
   // await deployer.deploy(TOS,DT.address)
   // await deployer.deploy(PR)
   let E=await deployer.deploy(NFT)
   let T=await deployer.deploy(TokenProxy,E.address)
   //await deployer.deploy(NFT,T.address,1)
   
      //let DT=await deployer.deploy(DummyToken)
      //await deployer.deploy(TOS,DT.address)
      
  //let E=await deployer.deploy(ERC1155)
     
   
    
  })
}
module.exports = deployContracts;
