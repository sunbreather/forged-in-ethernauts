// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Telephone.sol";

/// @custom:win-condition 
// Claim ownership of the contract to complete this level.

/// @custom:lesson-learned
// tx.origin and msg.sender are not the same. If A -> B -> C, A is tx.origin and B is msg.sender

contract TelephoneSolvedTest is Test {

  Telephone public s_telephone;
  address payable s_user;

  function setUp() public {
    s_telephone = new Telephone();
    s_user = payable(vm.addr(1));
    vm.deal(s_user, 100000000 ether);
  }

  function testWinCondition() public {
    vm.startPrank(s_user, address(this));

    s_telephone.changeOwner(s_user);

    assertEq(s_telephone.owner(), s_user);
  }
 
}