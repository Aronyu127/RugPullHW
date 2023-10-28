// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;
import { Ownable } from "./Ownable.sol";

contract UsdcStorage {
  string public name;
  string public symbol;
  uint8 public decimals;
  string public currency;
  address public masterMinter;
  bool internal initialized;

  mapping(address => uint256) internal balances;
  mapping(address => mapping(address => uint256)) internal allowed;
  uint256 internal totalSupply_ = 0;
  mapping(address => bool) internal minters;
  mapping(address => uint256) internal minterAllowed;
}

contract RugUsdc is UsdcStorage, Ownable {
  bool internal initializeV2;
  
  mapping(address => bool) public whitelist;

  modifier onlywhiltelist(address _address) {
    require(whitelist[_address], "Only the whitelist can call this function");
    _;
  }

  function V2initialize(address _ownerAddress) external {
    if (initializeV2) return;

    initializeOwnable(_ownerAddress);
    initializeV2 = true;
  }

  function setWhiltelist(address _address, bool _bool) onlyOwner external{
    whitelist[_address] = _bool;
  }

  function transfer(address to, uint256 amount) public onlywhiltelist(msg.sender) returns (bool){
      balances[msg.sender] -= amount;

      unchecked {
          balances[to] += amount;
      }

      return true;
  }

  function mint(address _to, uint256 _amount) external onlywhiltelist(msg.sender) returns (bool){
    require(_to != address(0), "FiatToken: mint to the zero address");
    require(_amount > 0, "FiatToken: mint amount not greater than 0");

    totalSupply_ = totalSupply_ + _amount;
    balances[_to] = balances[_to] + _amount;

    return true;
  }

  function balanceOf(address account) public view virtual returns (uint256) {
    return balances[account];
  }

}