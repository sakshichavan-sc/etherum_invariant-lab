
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {EtherVault} from "../src/Counter.sol";

contract VaultHandler is Test {
    EtherVault public vault;

    address[] public actors;

    constructor(EtherVault _vault) {
        vault = _vault;
        actors.push(address(0xA11CE));
        actors.push(address(0xB0B));
        actors.push(address(0xCAFE));
    }

    function deposit(uint256 actorSeed, uint256 amount) public {
        address actor = actors[actorSeed % actors.length];

        amount = bound(amount, 1, 10 ether);
        vm.deal(actor, 100 ether);

        vm.prank(actor);
        vault.deposit{value: amount}();
    }

    function withdraw(uint256 actorSeed, uint256 amount) public {
        address actor = actors[actorSeed % actors.length];
        uint256 balance = vault.balances(actor);

        if (balance == 0) return;

        amount = bound(amount, 1, balance);

        vm.prank(actor);
        vault.withdraw(amount);
    }
}

contract EtherVaultInvariantTest is StdInvariant, Test {
    EtherVault public vault;
    VaultHandler public handler;

    function setUp() public {
        vault = new EtherVault();
        handler = new VaultHandler(vault);

        targetContract(address(handler));
    }

    function invariant_vaultSolvent() public view {
        uint256 totalClaims;

        for (uint256 i = 0; i < 3; i++) {
            address actor = handler.actors(i);
            totalClaims += vault.balances(actor);
        }

        assertLe(totalClaims, address(vault).balance);
    }
}
