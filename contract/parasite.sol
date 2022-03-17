// SPDX-License-Identifier: Mozilla
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @custom:security-contact zhongliwang48@gmail.com
contract MyToken is ERC721, Ownable {
  using Counters for Counters.Counter;

  Counters.Counter private _tokenIdCounter;

  uint256 public constant maxSupply = 8888;
  uint256 public constant mintPrice = 0.01 ether;
  string public defaultURI = "https://ipfs.io/ipfs/QmWmx2YmKwdjNspAsfud9pbXqzAQyQzNNr8zu2etSXN3dZ";
  // Optional mapping for token URIs
  mapping(uint256 => string) private _tokenURIs;
  // 1 / address
  mapping(address => bool) public mintAddress;

  event TokenMinted(uint256 id);
  event TokenURIChanged(uint256 id, string uri);

  constructor() ERC721("Parasite", "Parasite") {}

  function _baseURI() internal view override returns (string memory) {
    return defaultURI;
  }
  function setBaseURI(string calldata uri) external onlyOwner {
    defaultURI = uri;
  }

  function safeMint(address to) public onlyOwner {
    uint256 tokenId = _tokenIdCounter.current();
    _tokenIdCounter.increment();
    _safeMint(to, tokenId);
    emit TokenMinted(tokenId);
  }

  function refundIfOver(uint256 price) private {
    require(msg.value >= price, "Need enough ETH.");
    if (msg.value > price) {
      payable(msg.sender).transfer(msg.value - price);
    }
  }

  function mint() external payable {
    require(!mintAddress[msg.sender], "The wallet has already minted.");
    uint256 tokenId = _tokenIdCounter.current();
    require(tokenId < maxSupply, "Exceed max supply.");
    mintAddress[msg.sender] = true;
    refundIfOver(mintPrice);
    _safeMint(msg.sender, tokenId);
    _tokenIdCounter.increment();
    emit TokenMinted(tokenId);
  }

  /**
    * @dev See {IERC721Metadata-tokenURI}.
    */
  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

    string memory _tokenURI = _tokenURIs[tokenId];
    string memory base = _baseURI();

    // If tokenURI or baseURI are set, return.
    if (bytes(_tokenURI).length > 0) {
      return _tokenURI;
    } else if (bytes(base).length > 0) {
      return base;
    }

    return super.tokenURI(tokenId);
  }

  /**
    * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
    *
    * Requirements:
    *
    * - `tokenId` must exist.
    */
  function setTokenURI(uint256 tokenId, string calldata uri) external {
    require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
    require(ownerOf(tokenId) == msg.sender, "Permission: You can't change other's data");
    _tokenURIs[tokenId] = uri;
    emit TokenURIChanged(tokenId, uri);
  }
}
