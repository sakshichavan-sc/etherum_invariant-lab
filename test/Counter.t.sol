
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {EtherVault} from "../src/Counter.sol";

contract EtherVaultTest is Test {
    EtherVault vault;

    address alice = address(0xA11CE);

    function setUp() public {
        vault = new EtherVault();
        vm.deal(alice, 10 ether);
    }

    function testDeposit() public {
        vm.prank(alice);
        vault.deposit{value: 1 ether}();

        assertEq(vault.balances(alice), 1 ether);
        assertEq(address(vault).balance, 1 ether);
    }

    function testWithdraw() public {
        vm.startPrank(alice);
        vault.deposit{value: 2 ether}();
        vault.withdraw(1 ether);
        vm.stopPrank();

        assertEq(vault.balances(alice), 1 ether);
        assertEq(address(vault).balance, 1 ether);
        assertEq(alice.balance, 9 ether);
    }

    function testCannotWithdrawMoreThanBalance() public {
        vm.prank(alice);
        vault.deposit{value: 1 ether}();

        vm.prank(alice);
        vm.expectRevert("Insufficient balance");
        vault.withdraw(2 ether);
    }
}

