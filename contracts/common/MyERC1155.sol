//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DinoNFT is ERC1155, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    mapping(uint256 => uint256) private _tokenSupply;

    string private _baseURI = "";
    string private baseExt = ".json";
    // Contract name
    string public name;
    // Contract symbol
    string public symbol;

    constructor(string memory _name, string memory _symbol) ERC1155("") {
        name = _name;
        symbol = _symbol;
    }

    function uri(uint256 _id)
        public
        view
        override
        returns (string memory _uri)
    {
        require(exists(_id), "ERC721#uri: NONEXISTENT_TOKEN");

        _uri = string(abi.encodePacked(_baseURI, _id.toString(), baseExt));
    }

    /**
     * @dev Returns the total quantity for a token ID
     * @param _id uint256 ID of the token to query
     * @return amount of token in existence
     */
    function totalSupply(uint256 _id) public view returns (uint256) {
        return _tokenSupply[_id];
    }

    /**
     * @dev Will update the base URL of token's URI
     * @param _uri New base URL of token's URI
     */
    function setBaseURI(string memory _uri) external onlyOwner {
        _baseURI = _uri;
    }

    /**
     * @dev Indicates whether any token exist with a given id, or not.
     */
    function exists(uint256 id) public view virtual returns (bool) {
        return totalSupply(id) > 0;
    }

    function mint(uint256 _tokenId, uint256 _amount) public onlyOwner {
        _mint(msg.sender, _tokenId, _amount, "");

        _tokenSupply[_tokenId] += _amount;
    }
}
