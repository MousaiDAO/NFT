pragma solidity >=0.5.0 <0.8.0;

contract Test{
    uint private count;
    address private owner;
    // address public constant approver = 0x94C9081c3Fc6DDF2F25426af516F9af82fA0F4ae;
    

    // events
    // event Increment();


    constructor() public{
        owner = msg.sender;
        
    }

    function increase() public returns (uint){
        count +=1;
        return count;
        // emit Increment();

    }

    function decrease() public returns (uint){
        count--;
        return count; 
    }

    function getCount() public view returns (uint){
        return count;
    }

    function setCount(uint _count) public returns(uint){
        count = _count;
    }

    //receive(encrypted seedphrase) push the encrypted word into the  smart contract
    //choseHolder(number,adresses) chainlink to chose a random holder
    //sendSeedPhrase() send encrypted seedphrase to holder
    //getListHolders(adresse , order) return the person adress to the user
    //storeContactList(adresse , order, randomMasterkey) store the holder contact list on ipfs
    // encrypt(pubkey,word) general function
    // earn(holderAdress,amount) send money to aave to earn interest
    // 

    function() payable external{}
}