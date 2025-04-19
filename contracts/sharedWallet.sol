
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SharedWallet{

    address public owner;

    constructor()  {
        owner = msg.sender;
    }


    modifier onlyOwner (){
        require(owner == msg.sender, "you are not allowed");
        _;
    }

    function withdrawMoney (address payable recipient, uint _amount) public onlyOwner{
        
        recipient.transfer(_amount);
    }
    
    function depositMoney () external payable{

    }
}