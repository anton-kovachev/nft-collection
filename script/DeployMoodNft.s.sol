//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() public returns (MoodNft moodNft) {
        string memory happySvg = vm.readFile("img/happy.svg");
        string memory sadSvg = vm.readFile("img/sad.svg");
        vm.startBroadcast();
        moodNft = new MoodNft(
            convertSvgToImageUri(happySvg),
            convertSvgToImageUri(sadSvg)
        );
        vm.stopBroadcast();
    }

    function convertSvgToImageUri(
        string memory svg
    ) public returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory base64EncodedSvg = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );

        return string(abi.encodePacked(baseURL, base64EncodedSvg));
    }
}
