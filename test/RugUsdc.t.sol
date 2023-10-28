// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { RugUsdc } from "../src/RugUsdc.sol";
// import { UpgradeableProxy } from "../src/UpgradeableProxy.sol";

interface UpgradeableProxy {
  // function upgradeTo(address newImplementation) external;
  function upgradeToAndCall(address newImplementation, bytes memory data) external;
}

contract RugUsdcTest is Test {
  // Contracts
  RugUsdc rugUsdc;
  RugUsdc proxyUsdc;
  string MAINNET_RPC_URL = "https://mainnet.gateway.tenderly.co/13eW7TkMJvLpfLminynri0";
  address USDC_CONTRACT_ADDRESS = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
  bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
  address ADMIN_ADDRESS;
  address user1;
  address user2;

  function bytes32ToAddress(bytes32 _bytes32) internal pure returns (address) {
    return address(uint160(uint256(_bytes32)));
  }  

  function setUp() public {
    vm.createSelectFork(MAINNET_RPC_URL, 18447897);
    rugUsdc = new RugUsdc();
    user1 = makeAddr("user1");
    user2 = makeAddr("user2");
    ADMIN_ADDRESS = bytes32ToAddress(vm.load(address(USDC_CONTRACT_ADDRESS), ADMIN_SLOT));

    //upgrade usdc proxy contract && set owner of usdc proxy contract
    vm.startPrank(ADMIN_ADDRESS);
    UpgradeableProxy(address(USDC_CONTRACT_ADDRESS)).upgradeToAndCall(address(rugUsdc), abi.encodeWithSelector(rugUsdc.V2initialize.selector, address(user1)));
    vm.stopPrank();
  }

  function testMint() public {
    proxyUsdc = RugUsdc(address(USDC_CONTRACT_ADDRESS));

    vm.startPrank(user1);
    proxyUsdc.setWhiltelist(address(user1), true);
    //user in whitelist can mint token
    proxyUsdc.mint(address(user1), 10000);
    vm.stopPrank();
    assertEq(proxyUsdc.balanceOf(address(user1)), 10000);

    //user not in whitelist can't mint token
    vm.startPrank(user2);
    vm.expectRevert();
    proxyUsdc.mint(address(user2), 10000);
    vm.stopPrank();
  }

  function testTransfer() public {
    proxyUsdc = RugUsdc(address(USDC_CONTRACT_ADDRESS));

    vm.startPrank(user1);
    proxyUsdc.setWhiltelist(address(user1), true);
    proxyUsdc.mint(address(user1), 100);
    proxyUsdc.mint(address(user2), 100);
    //user in whitelist can transfer token
    proxyUsdc.transfer(address(user2), 10);
    vm.stopPrank();

    //user not in whitelist can't transfer token
    vm.startPrank(user2);
    vm.expectRevert();
    proxyUsdc.transfer(address(user1), 10);
    vm.stopPrank();
  }
}