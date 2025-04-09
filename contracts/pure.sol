

// SPDX-License-Identifier: MIT


pragma solidity ^0.8.18;

contract Pure{
    uint256 num1 = 4;
    uint256 num2 = 10;

    function getData() public pure returns(uint256){
        uint256 Num1 = 12;
        uint256 Num2 = 40;
  uint256 sum = (Num1 + Num2);
  return sum;
    //   return (Num1, Num2);
      }

}