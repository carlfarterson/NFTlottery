pragma solidity ^0.5.0;

//import "@openzeppelin/contracts/ownership/Ownable.sol";
import './Ownable.sol';
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTlottery is Ownable{

    struct lottery{
        address[] participants;
        uint start;
        uint end;
        uint winners;
        uint[] tokens;
        
    }
    address private _owner;
    uint totalLotteries;
    ERC721 Digitible;
    mapping(uint=>lottery) public Lotteries;



    constructor(address NFT)  public {
        Digitible=ERC721(NFT);
        _owner=msg.sender;
    }

    function getLotteryTokens(uint l) public view returns(uint[] memory){
        return  Lotteries[totalLotteries].tokens;
    }

    function getLotteryParticipants(uint l) public view returns(address[] memory){
        return  Lotteries[totalLotteries].participants;
    }
    function createLottery(uint _start,uint _end,address[] memory _participants,uint[] memory _tokens) public onlyOwner {
        totalLotteries++;
        Lotteries[totalLotteries]=lottery(_participants,_start,_end,0,_tokens);
        
    }
    function validTime(uint _lottery) public view returns(bool){

         lottery storage L=Lotteries[_lottery];
        return ((L.start<now) && (L.end>now));
    }
    function addParticipants(uint _lottery,address[] memory _toadd) public onlyOwner{
        
        lottery storage L=Lotteries[_lottery];
        require((L.start<now)&&(L.end>now),"invalid time");
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
     /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}