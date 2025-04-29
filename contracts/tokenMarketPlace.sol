// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TokenMarketPlacen is Ownable, ReentrancyGuard {

    uint public feePercent;
    address public feeCollector;

    struct Listing {
        address seller;
        uint256 pricePerToken; 
        uint256 amount;
        address tokenAddress;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public nextListingsId = 1;

    event TokenListed(address indexed seller, address indexed tokenAddress, uint256 indexed listingId, uint256 amount, uint256 pricePerToken);

    constructor(uint256 _feePercent, address _feeCollector, address _initialOwner) Ownable(_initialOwner) {
        require(_feePercent <= 1000, "Fee cannot exceed 10%");
        require(_feeCollector != address(0), "Invalid fee collector address");
        feePercent = _feePercent;
        feeCollector = _feeCollector;
    }

    function ListToken(address _tokenAddress, uint256 _amount, uint256 _pricePerToken) external nonReentrant {
        require(_tokenAddress != address(0), "Invalid token address");
        require(_amount > 0, "Amount must be greater than 0");
        require(_pricePerToken > 0, "Price must be greater than 0");

        IERC20 token = IERC20(_tokenAddress);
        require(token.transferFrom(msg.sender, address(this), _amount), "Token transfer failed");

        uint256 listingId = nextListingsId++;
        listings[listingId] = Listing(msg.sender, _pricePerToken, _amount, _tokenAddress, true);

        emit TokenListed(msg.sender, _tokenAddress, listingId, _amount, _pricePerToken);
    }

    

    
}
