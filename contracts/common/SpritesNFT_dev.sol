// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract SpritesNFT is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Strings for uint256;
    using Counters for Counters.Counter;

    uint256 public mintPrice;
    uint256 public maxSupply; // max NFTs wallet can minted
    uint256 public maxPerWallet; // limit NFTs can mint per user
    bool public isPublicMintEnabled; // enable to mint for wallets
    string internal baseURI;
    string public baseExtension;
    address payable public withdrawWallet;

    mapping(address => uint256) public totalMintedPerWallet; // keep track of the number of NFTs per wallet

    constructor(string memory _name, string memory _symbol)
        payable
        ERC721(_name, _symbol)
    {
        mintPrice = 0.02 ether;
        maxSupply = 50;
        maxPerWallet = 3;
        baseExtension = ".json";
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setIsPublicMintEnabled(bool _isPublicMintEnabled)
        external
        onlyOwner
    {
        isPublicMintEnabled = _isPublicMintEnabled;
    }

    function setTokenURI(string memory _baseTokenURI) external onlyOwner {
        baseURI = _baseTokenURI;
    }

    function canMint(address _from) public view returns (bool) {
        return totalMintedPerWallet[_from] < maxPerWallet;
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

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        baseURI,
                        _tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    function withdraw() external onlyOwner {
        (bool success, ) = withdrawWallet.call{value: address(this).balance}(
            ""
        );
        require(success, "withdraw failed");
    }

    function mint(uint256 _quantity) public payable {
        uint256 totalSupplyMinted = totalSupply();
        totalMintedPerWallet[msg.sender] = totalMintedPerWallet[msg.sender].add(
            _quantity
        );

        require(isPublicMintEnabled, "Minting is not enable");
        require(msg.value <= mintPrice.mul(_quantity), "wrong mint value");
        require(totalSupplyMinted.add(_quantity) <= maxSupply, "sold out");
        require(
            totalMintedPerWallet[msg.sender] <= maxPerWallet,
            "wallet reached max minting able"
        );

        for (uint256 index = 1; index <= _quantity; index++) {
            uint256 newTokenId = totalSupplyMinted.add(index);
            _safeMint(msg.sender, newTokenId);
        }
    }
}
