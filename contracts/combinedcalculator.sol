
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;




    contract Calculator{

    address public owner;
    address public ScientificCalculatorAddress;


    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only Owner can initiate this action");
        _;
    }

    function setScientificCalculator(address _address) public onlyOwner{
        ScientificCalculatorAddress = _address;
    }

    function add(uint256 a, uint256 b)public pure returns(uint256){
        uint256 result = a+b;
        return result;
    }

      function subtract(uint256 a, uint256 b)public pure returns(uint256){
        uint256 result = a-b;
        return result;
    }

       function multiply(uint256 a, uint256 b)public pure returns(uint256){
        uint256 result = a*b;
        return result;
    }

         function divide(uint256 a, uint256 b)public pure returns(uint256){
            require(b!= 0, "Cannot divide by zero");
        uint256 result = a/b;
        return result;
    }

    function calculatePower(uint256 base, uint256 exponent) public view returns(uint256){

    ScientificCalculator scientificCalc = ScientificCalculator(ScientificCalculatorAddress);

    // external call
    uint256 result = scientificCalc.power(base,exponent);

    return result;
}

   function calculateSquareRoot(uint256 number)public returns (uint256){
    require(number >= 0, "Cannot find square root of a negative number");
    bytes memory data = abi.encodeWithSignature("SquareRoot(int256)", number);
    (bool success, bytes memory returnData) = ScientificCalculatorAddress.call(data);
    require(success, "External call Failed");
    uint256 result = abi.decode(returnData, (uint256));
    return result;
    
   }


}


    contract ScientificCalculator{

    function power(uint256 base, uint256 exponent) public pure returns(uint256){
        if(exponent == 0) return 1;
        else return (base ** exponent);
    }

    function squareRoot(int256 number) public pure returns (int256){
        require(number > 0, "Cannot calculate square root of a negative number,Number should be greater than zero");
        if (number == 0) return 0;

        int256 result = number/2;
        for(uint256 i = 0; 1 <10; i++){
            result = (result + number / result)/2;
        }

        return result;
    }
}

