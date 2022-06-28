// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../base/BaseSpriteNFT.sol";

contract SpritesUpgradeable is
    BaseSpriteNFT,
    ERC721EnumerableUpgradeable,
    OwnableUpgradeable
{
    using SafeMath for uint256;
    using Strings for uint256;
    using Counters for Counters.Counter;

    /**
     * @param _maxSupply: max can be minting
     * @param _maxPerWallet: limit minting per user
     * @param _baseExtension: base extensions
     * @param _name: name token collections
     * @param _symbol: symbol token collections
     * @param _admin: admin address with ownership
     */
    function initialize(
        uint256 _maxSupply,
        uint256 _maxPerWallet,
        string memory _baseExtension,
        string memory _name,
        string memory _symbol,
        address _admin
    ) external initializer {
        __BaseSpriteNFT_init(_maxSupply, _maxPerWallet, _baseExtension);
        __ERC721_init(_name, _symbol);
        __Ownable_init();

        transferOwnership(_admin);
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
