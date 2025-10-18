//SPDX // SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract DeployBasicNFT is Script {
    function run() public returns (BasicNFT basicNft) {
        vm.startBroadcast();
        basicNft = new BasicNFT();
        console.log("Address: ", address(basicNft));
        vm.stopBroadcast();
    }
}
