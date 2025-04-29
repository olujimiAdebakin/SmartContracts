

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



function removeLiquidity(uint256 liquidityToRemove) external returns (uint256 amountAOut, uint256 amountBOut) {
    // Ensure the user is removing more than zero liquidity
    require(liquidityToRemove > 0, "Liquidity to remove must be > 0");

    // Check the user has enough LP tokens to remove the specified liquidity
    require(balanceOf(msg.sender) >= liquidityToRemove, "Insufficient liquidity tokens");

    // Get the total supply of LP tokens in existence
    uint256 totalLiquidity = totalSupply();
    require(totalLiquidity > 0, "No liquidity in the pool");

    // Calculate how much tokenA and tokenB the user should receive based on their share
    amountAOut = (liquidityToRemove * reserveA )/ totalLiquidity;
    amountBOut = (liquidityToRemove * reserveB) / totalLiquidity;

    // Ensure the calculated output is non-zero (i.e., reserves aren't too low)
    require(amountAOut > 0 && amountBOut > 0, "Insufficient reserves for requested liquidity");

    // Update the internal reserves to reflect the withdrawal
    reserveA -= amountAOut;
    reserveB -= amountBOut;

    // Burn the LP tokens from the user, reducing their pool ownership
    _burn(msg.sender, liquidityToRemove);

    // Transfer the underlying tokens back to the user
    tokenA.transfer(msg.sender, amountAOut);
    tokenB.transfer(msg.sender, amountBOut);

    // Emit an event to log the removal of liquidity
    emit LiquidityRemoved(msg.sender, amountAOut, amountBOut, liquidityToRemove);

    // Return the amounts of tokens withdrawn
    return (amountAOut, amountBOut);
}



function swapAforB(uint256 amountAIn, uint256 minBOut) external {
    // Make sure input amount is non-zero
    require(amountAIn > 0, "Amount must be > 0");

    // Check if reserves are available to make a swap
    require(reserveA > 0 && reserveB > 0, "Insufficient reserves");

    // Apply a 0.3% fee (commonly used in DEXs like Uniswap)
    uint256 amountAInWithFee = amountAIn * 997 / 1000;

    // Constant product formula: x * y = k => calculate output
    uint256 amountBOut = reserveB * amountAInWithFee / (reserveA + amountAInWithFee);

    // Ensure output meets user's minimum expected amount (slippage protection)
    require(amountBOut >= minBOut, "Slippage too high");

    // Transfer tokenA from user to contract
    tokenA.transferFrom(msg.sender, address(this), amountAIn);

    // Transfer tokenB to the user
    tokenB.transfer(msg.sender, amountBOut);

    // Update reserves: add effective tokenA amount (after fee), reduce tokenB
    reserveA += amountAInWithFee;
    reserveB -= amountBOut;

    // Emit event to log the swap
    emit TokensSwapped(msg.sender, address(tokenA), amountAIn, address(tokenB), amountBOut);
}



 
function swapBforA(uint256 amountBIn, uint256 minAOut) external {
    // Check for valid input
    require(amountBIn > 0, "Amount must be > 0");

    // Ensure reserves exist
    require(reserveA > 0 && reserveB > 0, "Insufficient reserves");

    // Apply 0.3% fee to input
    uint256 amountBInWithFee = amountBIn * 997 / 1000;

    // Calculate output amount using constant product formula
    uint256 amountAOut = reserveA * amountBInWithFee / (reserveB + amountBInWithFee);

    // Ensure slippage isn't too high
    require(amountAOut >= minAOut, "Slippage too high");

    // Take tokenB from sender
    tokenB.transferFrom(msg.sender, address(this), amountBIn);

    // Send tokenA to sender
    tokenA.transfer(msg.sender, amountAOut);

    // Update reserves accordingly
    reserveB += amountBInWithFee;
    reserveA -= amountAOut;

    // Emit swap event
    emit TokensSwapped(msg.sender, address(tokenB), amountBIn, address(tokenA), amountAOut);
}



function getReserves() external view returns (uint256, uint256) {
    // Allow external users to view the current reserves of tokenA and tokenB
    return (reserveA, reserveB);
}
         

}
  