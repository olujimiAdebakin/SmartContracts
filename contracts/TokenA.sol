

 
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20 {
    constructor() ERC20("Token A", "TKA") {
        _mint(msg.sender, 1000000000 * 10 ** decimals()); // Mint 1 billion tokens to you
    }
}

