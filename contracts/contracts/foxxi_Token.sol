// contracts/OceanToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract FoxxiToken is ERC20Capped, ERC20Burnable {
  address payable public owner;

  /** Remove this comment and the comments regarding minerReward if you wish to reward the miners */
  //uint256 public blockReward;

  /**@param maximumSupply is the maximum number of tokens that can be minted
  @param initialSupplyToOwner is the number of tokens that will be minted and sent to the owner's address
  Remove the comment from minerReward if you wish to give rewards to the miners
 */
  constructor(
    uint256 maximumSupply,
    /*uint256 minerReward,*/
    uint256 initialSupplyToOwner
  ) ERC20("FoxxiToken", "FXI") ERC20Capped(maximumSupply * (10 ** decimals())) {
    owner = payable(msg.sender);
    _mint(owner, initialSupplyToOwner * (10 ** decimals()));
    /*blockReward = minerReward;*/
  }

  function _mint(
    address account,
    uint256 amount
  ) internal virtual override(ERC20Capped, ERC20) {
    require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
    super._mint(account, amount);
  }

  function destroy() public onlyOwner {
    selfdestruct(owner);
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the owner can call this function");
    _;
  }

  function approveCustom(
    address tokenOwner,
    address spender,
    uint256 amount
  ) public virtual returns (bool) {
    _approve(tokenOwner, spender, amount);
    return true;
  }

  function transferFromCustom(
    address from,
    address to,
    uint256 amount
  ) public virtual returns (bool) {
    _approve(from, msg.sender, amount);
    console.log("allowance", allowance(from, msg.sender));
    _spendAllowance(from, msg.sender, amount);
    _transfer(from, to, amount);
    return true;
  }
  /**
   Remove the comments from the code below to give rewards to the miners
   */
  //   function _mintMinerReward() internal {
  //     _mint(block.coinbase, blockReward);
  //   }

  //   function _beforeTokenTransfer(
  //     address from,
  //     address to,
  //     uint256 value
  //   ) internal virtual override {
  //     if (
  //       from != address(0) && to != block.coinbase && block.coinbase != address(0)
  //     ) {
  //       _mintMinerReward();
  //     }
  //     super._beforeTokenTransfer(from, to, value);
  //   }

  //   function setBlockReward(uint256 minerReward) public onlyOwner {
  //     blockReward = minerReward * (10 ** decimals());
  //   }
}