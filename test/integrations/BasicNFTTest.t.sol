//SPDX // SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";
import {DeployBasicNFT} from "../../script/DeployBasicNFT.s.sol";

contract BasicNftTest is Test {
    DeployBasicNFT private deployer;
    BasicNFT private basicNFT;

    string private constant PUG_URI =
        "ipfs://QmQauCDma4Rtkcbg6EZVqsKnmDH2QMV3NBjwEf7VXBH2JD/?filename=bear-metadata.json";

    address bob = makeAddr("Bob");

    function setUp() public {
        deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNFT.name();

        assertEq(
            keccak256(abi.encodePacked(expectedName)),
            keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMinAndHaveABalance() public {
        vm.prank(bob);
        basicNFT.mintNft(PUG_URI);

        assert(
            keccak256(abi.encodePacked(PUG_URI)) ==
                keccak256(abi.encodePacked(basicNFT.tokenURI(0)))
        );
        assertEq(basicNFT.balanceOf(bob), 1);
    }
}
