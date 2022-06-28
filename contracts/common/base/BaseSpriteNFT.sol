// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract BaseSpriteNFT is Initializable {
    uint256 public mintPrice; // fee mint
    uint256 public maxSupply; // max NFTs wallet can minted
    uint256 public maxPerWallet; // limit NFTs can mint per user
    bool public isPublicMintEnabled; // enable to mint for wallets
    string internal baseURI;
    string public baseExtension;
    address payable public withdrawWallet;

    mapping(address => uint256) public totalMintedPerWallet; // keep track of the number of NFTs per wallet

    function __BaseSpriteNFT_init(
        uint256 _maxSupply,
        uint256 _maxPerWallet,
        string memory _baseExtension
    ) internal onlyInitializing {
        mintPrice = getDefaultFee();
        maxSupply = _maxSupply;
        maxPerWallet = _maxPerWallet;
        baseExtension = _baseExtension;
    }

    function getDefaultFee() public pure returns (uint256) {
        return 0.02 ether;
    }
}
