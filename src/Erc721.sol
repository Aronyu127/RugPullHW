// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyMint is ERC721, Ownable(msg.sender) {
    uint256 public constant maxTokens = 500;
    uint256 public tokensMinted;
    constructor(
        string memory name_,    // Name of the token
        string memory symbol_   // Symbol of the token
    ) ERC721(name_, symbol_) {}

    function mint(uint256 numberOfTokens) external {
        require(tokensMinted + numberOfTokens <= maxTokens, "Exceeds maximum number of tokens");

        for (uint256 i = 0; i < numberOfTokens; i++) {
            tokensMinted++;
            uint256 tokenId = tokensMinted;
            _mint(msg.sender, tokenId);
        }
    }
}