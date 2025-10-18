//SPDX // SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftTest is Test {
    DeployMoodNft deployer;
    string constant SVG_IMAGE =
        '<svg width="300" height="130" xmlns="http://www.w3.org/2000/svg"><rect width="200" height="100" x="10" y="10" rx="20" ry="20" fill="blue" />Sorry, your browser does not support inline SVG.</svg>';
    string constant SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjEzMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMjAwIiBoZWlnaHQ9IjEwMCIgeD0iMTAiIHk9IjEwIiByeD0iMjAiIHJ5PSIyMCIgZmlsbD0iYmx1ZSIgLz5Tb3JyeSwgeW91ciBicm93c2VyIGRvZXMgbm90IHN1cHBvcnQgaW5saW5lIFNWRy48L3N2Zz4=";

    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testConvertSvgToImageUri() public {
        string memory imageUri = deployer.convertSvgToImageUri(SVG_IMAGE);
        console.log("ImageUri: ", imageUri);
        bytes32 imageUriHash = keccak256(abi.encodePacked(imageUri));
        bytes32 svgUriHash = keccak256(abi.encodePacked(SVG_IMAGE_URI));

        assertEq(imageUriHash, svgUriHash);
    }
}
