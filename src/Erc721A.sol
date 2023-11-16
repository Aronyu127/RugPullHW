// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";

contract MyMint is ERC721A, Ownable(msg.sender) {
    constructor(
        string memory name_,    // Name of the token
        string memory symbol_   // Symbol of the token
    ) ERC721A(name_, symbol_) {}

    function mint(uint256 quantity) external payable {
        _mint(msg.sender, quantity);
    }

    // override start token id from 0 to 1
    function _startTokenId() override internal view virtual returns (uint256) {
        return 1;
    }

}