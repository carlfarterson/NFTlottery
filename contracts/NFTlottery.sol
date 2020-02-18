pragma solidity ^0.5.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTlottery is Ownable{

    struct lottery{
        address[] participants;
        uint start;
        uint end;
        uint winners;
        uint[] tokens;
        
    }

    uint totalLotteries;
    ERC721 Digitible;
    mapping(uint=>lottery) Lotteries;



    constructor(address NFT) public {
        Digitible=ERC721(NFT);
    }

    function createLottery(uint _start,uint _end,address[] memory _participants,uint[] memory _tokens) public onlyOwner {
        Lotteries[totalLotteries]=lottery(_participants,_start,_end,0,_tokens);
        totalLotteries++;
    }

    function addParticipant(uint _lottery,address[] memory _toadd) public onlyOwner{
        
        lottery storage L=Lotteries[_lottery];
        require((L.start)<now&&(L.end<now),"invalid time");
        for(uint i=0;i<_toadd.length;i++){
            L.participants.push(_toadd[i]);
        }
        
    }
    function setWinner(uint _lottery) public onlyOwner{
         
         lottery storage L=Lotteries[_lottery];
         require((L.participants.length>0)&&(L.tokens.length>0));
         require(L.winners<L.tokens.length);
         uint index=random(L.participants.length);

         
         
         _burnParticipant(index, _lottery);
         transferNFT(L.tokens[L.winners],L.participants[index]);
         L.winners++;
         L.participants[index]=address(0);
    }

    function transferNFT(uint id,address a) internal{
        Digitible.transferFrom(address(this),a,id);
    }
    function random(uint modulus) internal returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, now))) % modulus;
    }

    function _burnParticipant(uint index,uint _lottery) internal {
        address[] storage array = Lotteries[_lottery].participants;
        require(index < array.length,"invalid index");
        array[index] = array[array.length-1];
        delete array[array.length-1];
        array.length--;
    }
}