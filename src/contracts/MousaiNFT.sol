pragma solidity >=0.6.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/access/Ownable.sol";
import "./MinterRole.sol";
import "./IERC2981.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/utils/EnumerableMap.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
//import "https://github.com/itinance/openzeppelin-solidity/blob/master/contracts/token/ERC721/ERC721Full.sol";



contract MousaiNFT is ERC721, MinterRole, IERC2981, Ownable{
    
     using SafeMath for uint;
     
     
     uint private _supplyCap;
     mapping (uint256 => uint256) private _tokenRoyalty;
     
     
     /*
     * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
     * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
     *
     * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
     */
    //bytes4 private constant _INTERFACE_ID_RARIBLE_FEES = 0xb7799584;

    /*
     * ERC165 bytes to add to interface array - set in parent contract implementing this standard
     *
     * 
     */
    bytes4 private constant _INTERFACE_ID_ERC721ROYALTIES = 0x4b7f2c2d;
    
    address payable public creator;
    
   
  
  constructor (string memory name, string memory symbol, string memory baseURI, uint256 _royaltyAmount, uint256 supplyCap)  
    public  ERC721("MouSai", "MOUSAI") 
  {
      _setBaseURI(baseURI);
      
      setInitialRoyalty(_royaltyAmount);
      creator = msg.sender;
      _supplyCap = supplyCap;
      _registerInterface(_INTERFACE_ID_ERC721ROYALTIES);
  }
  
  //called by creator/artist when receiving event ReceivedRoyalties to reset _tokenRoyalty for resale
  function setTokenIdRoyalty(uint256 tokenId, uint256 _royaltyPercentage) public onlyOwner{
      require(tokenId <= _supplyCap, "invalid tokenId" );
         _tokenRoyalty[tokenId] = _royaltyPercentage;
  }
     

  function setInitialRoyalty(uint256 _royaltyPercentage) public onlyOwner{
         for (uint tokenId=0; tokenId<_supplyCap; tokenId++){
            _tokenRoyalty[tokenId] = _royaltyPercentage;
         }
     }
  
   // Implements the current version of https://eips.ethereum.org/EIPS/eip-2981
    function royaltyInfo(uint256 _tokenId) external view override returns (address receiver, uint256 amount) {
        return (creator, _tokenRoyalty[_tokenId]);
    }
    
  
  function getCreator() public view returns (address payable){
      return creator;
  }
  
  function getRoyaltyPercentage(uint _tokenId) public returns (uint256){
      return _tokenRoyalty[_tokenId];
  }
  
  function setTokenSupplyCap(uint max) public onlyOwner{
      _supplyCap = max;
  }

  function mintNFT(address _to, uint256 _tokenId) public onlyMinter{
      require(_tokenId <= _supplyCap && _tokenId > 0, "Invalid tokenId");
      _safeMint(_to, _tokenId);
  }
    
  function mint(address _to) public onlyMinter returns (bool) {
      require(totalSupply() > 0, "No MousaiNFT");
      _mintWithTokenURI(_to, tokenURI(totalSupply()));
      return true;
  }
  
  function mint(address _to, string memory _tokenURI) public onlyMinter returns (bool) {
      _mintWithTokenURI(_to, _tokenURI);
      return true;
  }

  function _mintWithTokenURI(address _to, string memory _tokenURI) internal onlyMinter{
      require(totalSupply() < _supplyCap, "All sold out");
      uint _tokenId = totalSupply().add(1);
      _mint(_to, _tokenId);
      _setTokenURI(_tokenId, _tokenURI);
  }
  
  
  function receivedRoyalties(address _royaltyRecipient, address _buyer, uint256 _tokenId, address _tokenPaid, uint256 _amount) override external{
      emit ReceivedRoyalties(_royaltyRecipient, _buyer, _tokenId, _tokenPaid, _amount);
  }

}