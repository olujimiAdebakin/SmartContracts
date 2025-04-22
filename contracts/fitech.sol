
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Fitech {

    address owner; //owners address

    // constructor
    constructor(){
        owner = msg.sender;
    }


    // writing functions
    function donate() public payable {
        // this function receives ETH
        payable (address(this)).transfer(msg.value);

    }

    receive() external payable {}


    function withdraw() public payable {
        // this function will withdraw donation to jimi

        // Only the owner can withdraw the fund
        // using the Require
        require(msg.sender == owner, "you are not the owner");

        // this is fetching the current balance fo the contract
        uint256 currentBalanceOfThisContract = balance();

        // this is sending the funds to 'owner'
        payable(owner).transfer(currentBalanceOfThisContract);

    }

      function balance() public view returns(uint256) {
        // this function checks the balance of donation

        return address(this).balance;

    }






}