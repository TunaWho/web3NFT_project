// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract RoboPunksNFT is ERC721, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    uint256 public mintPrice;
    Counters.Counter public totalSupplyMinted; // the current number of NFTs wallet minted
    uint256 public maxSupply; // max NFTs wallet can minted
    uint256 public maxPerWallet; // limit NFTs can mint per user
    bool public isPublicMintEnabled; // enable to mint for wallets
    string internal baseTokenUri;
    address payable public withdrawWallet;

    mapping(address => uint256) public totalMintedPerWallet; // keep track of the number of NFTs per wallet

    constructor() payable ERC721("RoboPunksMega", "RPM") {
        mintPrice = 0.02 ether;
        totalSupplyMinted._value = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
    }

    function setIsPublicMintEnabled(bool _isPublicMintEnabled)
        external
        onlyOwner
    {
        isPublicMintEnabled = _isPublicMintEnabled;
    }

    function setBaseTokenUri(string calldata _baseTokenUri) external onlyOwner {
        baseTokenUri = _baseTokenUri;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return
            string(
                abi.encodePacked(
                    baseTokenUri,
                    Strings.toString(_tokenId),
                    ".json"
                )
            );
    }

    function withdraw() external onlyOwner {
        (bool success, ) = withdrawWallet.call{value: address(this).balance}(
            ""
        );
        require(success, "withdraw failed");
    }

    function mint(uint256 _quantity) public payable {
        require(isPublicMintEnabled, "Minting is not enable");
        require(msg.value <= mintPrice.mul(_quantity), "wrong mint value");
        require(
            totalSupplyMinted._value.add(_quantity) <= maxSupply,
            "sold out"
        );
        require(
            totalMintedPerWallet[msg.sender].add(_quantity) <= maxPerWallet,
            "wallet reached max minting able"
        );

        for (uint256 index = 0; index < _quantity; index++) {
            uint256 newTokenId = totalSupplyMinted._value.add(1);
            totalSupplyMinted.increment();
            _safeMint(msg.sender, newTokenId);
        }
    }
}
