// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {MyMint} from "../src/Erc721A.sol";

contract Erc721ATest is Test {
    MyMint private my_mint;

    function setUp() public {
        my_mint = new MyMint("MyMint", "MM");
    }

    function testMint() public {
        uint256 tokenId = 1;
        my_mint.mint(1);
        assertEq(
            my_mint.ownerOf(tokenId),
            address(this),
            "Token owner should be the test contract"
        );
    }

    function testMulitpleMint() public {
        uint256 mint_amount = 5;
        my_mint.mint(mint_amount);
        assertEq(
            my_mint.balanceOf(address(this)),
            mint_amount,
            "Token owner should be the test contract"
        );
    }

    function testTransfer() public {
        uint256 tokenId = 1;
        address to = address(0x123);
        my_mint.mint(1);
        my_mint.transferFrom(address(this), to, tokenId);
        assertEq(
            my_mint.ownerOf(tokenId),
            to,
            "Token owner should be the new owner"
        );
    }

    function testSafeTransfer() public {
        uint256 tokenId = 1;
        address to = address(0x123);
        bytes memory data = "test";
        my_mint.mint(1);
        my_mint.safeTransferFrom(address(this), to, tokenId, data);
        assertEq(
            my_mint.ownerOf(tokenId),
            to,
            "Token owner should be the new owner"
        );
    }

    function testApprove() public {
        uint256 tokenId = 1;
        address to = address(0x123);
        my_mint.mint(1);
        my_mint.approve(to, tokenId);
        assertEq(
            my_mint.getApproved(tokenId),
            to,
            "Token approved address should be the new owner"
        );
    }
}
