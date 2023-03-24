// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Vault.sol";

/// @custom:win-condition 
/// Unlock the vault to pass the level!


/// @custom:lesson-learned
/// nothing on the blockchain is secret or private 

contract VaultSolvedTest is Test {

  Vault public s_vault;
  address payable s_user;

  function setUp() public {
    s_vault = new Vault("dont look!");
    s_user = payable(vm.addr(1));
    vm.deal(s_user, 100000000 ether);
  }

  function testWinCondition() public {
    vm.startPrank(s_user);

    bytes32 storageSlot = vm.load(address(s_vault), bytes32(uint256(1)));

    s_vault.unlock(storageSlot);

    assertFalse(s_vault.locked());
  }
 
}