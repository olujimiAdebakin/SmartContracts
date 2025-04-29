

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Automated Market Maker with Liquidity Token
contract AutomatedMarketMaker is ERC20 {

      IERC20 public tokenA;
    IERC20 public tokenB;

    // track the number of token in the reserve
    // These two numbers track how much of each token is currently locked inside the AMM contract.
    // Why do we need this?

// Because the **entire AMM logic — swaps, prices, LP shares — depends on knowing how much of each token is in the pool.**
    uint256 public reserveA;
    uint256 public reserveB;

    address public owner;


// These are events, and while they don’t affect how the contract works under the hood, they play a huge role in how apps and users interact with it.
    
event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB, uint256 liquidity);
event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB, uint256 liquidity);
event TokensSwapped(address indexed trader, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);


      constructor(address _tokenA, address _tokenB, string memory _name, string memory _symbol) ERC20(_name, _symbol) {
  tokenA = IERC20(_tokenA);
  tokenB = IERC20(_tokenB);
  owner = msg.sender;
}


 
// Returns the smaller of two unsigned integers
function min(uint256 a, uint256 b) internal pure returns (uint256) {
    // Use a ternary operator: if a < b, return a; else return b
    return a < b ? a : b;
}


// Returns the integer square root of a number using the Babylonian method
function sqrt(uint256 y) internal pure returns (uint256 z) {
    // If y > 3, use the Babylonian method to approximate the square root
    if (y > 3) {
        // Start with an initial guess: z = y
        z = y;

        // Another guess: x = (y / 2) + 1
        uint256 x = y / 2 + 1;

        // Repeat approximation until x >= z
        // The loop stops when the estimate stops improving
        while (x < z) {
            z = x;
            // Average of x and y / x — classic Babylonian step
            x = (y / x + x) / 2;
        }
    } 
    // Handle small values of y (1 to 3): return 1
    else if (y != 0) {
        z = 1;
    }
    // If y == 0, z stays as default 0 (implicitly returned)
}


// Main function to allow users to add liquidity to a tokenA/tokenB pool
function addLiquidity(uint256 amountA, uint256 amountB) external {
    // Ensure that both input amounts are greater than 0
    require(amountA > 0 && amountB > 0, "Amounts must be > 0");

    // Transfer tokens from the user to the contract (liquidity pool)
    tokenA.transferFrom(msg.sender, address(this), amountA);
    tokenB.transferFrom(msg.sender, address(this), amountB);

    // Declare a variable to hold the amount of LP tokens to be minted
    uint256 liquidity;

    // If this is the first liquidity being added, total supply is 0
    if (totalSupply() == 0) {
        // Use geometric mean for initial LP token supply
        liquidity = sqrt(amountA * amountB);
    } else {
        // For subsequent adds, calculate LP tokens based on current reserve ratio
        liquidity = min(
            amountA * totalSupply() / reserveA,  // LP tokens based on tokenA contribution
            amountB * totalSupply() / reserveB   // LP tokens based on tokenB contribution
        );
    }

    // Mint LP tokens to the user as proof of their share in the pool
    _mint(msg.sender, liquidity);

    // Update internal reserves to match the actual token amounts now in the contract
    reserveA += amountA;
    reserveB += amountB;

    // Emit an event to log the liquidity addition
    emit LiquidityAdded(msg.sender, amountA, amountB, liquidity);
}








          

}
  