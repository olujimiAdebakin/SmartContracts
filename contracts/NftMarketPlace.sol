

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract NFTMarketPlace is ReentrancyGuard{

    address public owner;
    uint256 public marketplacefeepercent; ///in basis points  = 100 = 1%
    address public feeRecipient;

    struct Listing{
        address seller;
        address nftAddress;
        uint256 tokenId;
        uint256 price;
        address royaltyReceiver;
        uint256 royaltyPercent;
        bool isListed;
    }

    mapping(address => mapping (uint256 => Listing)) public Listings;

    event Listed(
        address indexed  seller,
         address indexed nftAddress,
          uint256 indexed tokenId, 
          uint256 price,
           address royaltyReceiver,
            uint256 royaltyPercent,
             bool isListed 
             );

             event Purchased(
                address indexed  buyer,
         address indexed nftAddress,
          uint256 indexed tokenId, 
          uint256 price,
          address seller,
           address royaltyReceiver,
            uint256 royaltyAmount,
            uint256 marketPlaceFeeAmount,
             bool isListed 
             );

             event unListed(
                address indexed seller, 
                address indexed nftAddress,
                uint256 tokenId
                );

                event feeUpdated(
                    uint256 newMArketPlaceFee,
                    address newFeeReceipt
                );


                constructor(uint256 _marketFeePercent, address _feeRecepient){
                    require(_marketFeePercent <= 1000, "Market fee too high maximum 10%");
                }


  
}