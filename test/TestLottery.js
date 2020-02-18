let Lottery =artifacts.require('./NFTlottery.sol')
let testNFT=artifacts.require('./testNFT.sol')
let now=Date.now()
const {
    BN,           // Big Number support
    constants,   
    time,  
    expectRevert,
  } = require('@openzeppelin/test-helpers');

contract('testing a lottery',(accounts)=>{
    before(async()=>{
        let NFT=await testNFT.new()
        console.log("nft")
        console.log(NFT.address)
        let lottery=await Lottery.new()
        NFT.mint(lottery.address,1)   
        NFT.mint(lottery.address,2)   
        NFT.mint(lottery.address,3)
        NFT.mint(lottery.address,4)   
        NFT.mint(lottery.address,5)      
    })
   it("creates a new lottery",async()=>{
    let users=[accounts[0],accounts[1],accounts[2],[accounts[4]]]
    await Lottery.createLottery(now,now+100,users,[1,2,3,4,5])
   
    await time.increase(time.duration.seconds(2));
    await Lottery.addParticipants(1, [accounts[5],accounts[6]])
   })


})