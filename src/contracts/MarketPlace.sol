pragma solidity >=0.6.0 <0.8.0;

import "./MousaiNFT.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/math/Math.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC20/ERC20.sol";

// Sell NFTs on a decaying curve.
contract MarketPlace {
    using SafeMath for uint256;

    uint public constant FIRST_ID = 1;
    uint public constant LAST_ID = 8;

    uint public constant MIN_PRICE = 0.2 ether;
    uint public constant MAX_PRICE = 1 ether;

    uint256 currentId = FIRST_ID;
    uint256 lastMintPrice = 0;
    uint256 lastSoldAt = 0;

    MousaiNFT public nftContract;

    constructor (address mousaiAddress) {
        nftContract = MousaiNFT(mousaiAddress);
    }

   /* function checkRoyalties(address _token) internal  returns (bool) {
        (bool success) = address(nftContract).call(abi.encodeWithSignature("royaltyInfo(uint256)"));
        return success;
     }*/
     
     function buyNFT( uint _tokenId, address _tokenPaid, uint256 _amount) external  returns (uint256) {
         uint256 royaltyPercentage = nftContract.getRoyaltyPercentage(_tokenId);
         uint256 royalty = _amount.mul(royaltyPercentage).div(100000);
         ERC20(_tokenPaid).transfer(nftContract.getCreator(), royalty);
         nftContract.receivedRoyalties(nftContract.getCreator(), msg.sender, _tokenId, _tokenPaid, royalty);
         return _tokenId;
    }
    
    function buyNFTWithEth( uint _tokenId, uint256 _amount) external  payable returns (uint256) {
        uint256 royaltyPercentage = nftContract.getRoyaltyPercentage(_tokenId);
        uint256 royalty = msg.value.mul(royaltyPercentage).div(100000);
        nftContract.getCreator().transfer(royalty);
        nftContract.receivedRoyalties(nftContract.getCreator(), msg.sender, _tokenId, address(0), royalty);
        return _tokenId;
    }
    
    function getPriceToMint(uint256 idx) public virtual view returns (uint256) {
       uint256 mintPrice;

        return mintPrice;
    }
}