// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
 
contract Token is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
 
    constructor() ERC20("Chainlink Bootcamp 2025 Token", "CLB25") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }
 
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
 
    function decimals() public pure override returns (uint8) {
        return 2;
    }    
}

// 0x45630a7Db07604f82a1D2ccf8509eb375b1826C6

// 0x45630a7Db07604f82a1D2ccf8509eb375b1826C6