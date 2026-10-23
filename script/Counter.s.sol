
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {EtherVault} from "../src/Counter.sol";

contract CounterScript is Script {
    function run() external {
        vm.startBroadcast();
        new EtherVault();
        vm.stopBroadcast();
    }
}

