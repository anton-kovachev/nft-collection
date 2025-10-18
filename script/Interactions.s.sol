//SPDX // SPDX-License-Identifier: MIT

pragma solidity 0.8.24;
import {Script, console} from "forge-std/Script.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNFT is Script {
    string private constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=bear-metadata.json";

    function run() external {
        console.log("ChainId \n");
        console.log(block.chainid);

        // address mostRecentlyDeployedBasicNft = 0x9b0A159c930CD13d5e6B73Cc4F8fc8c538032bDC;
        address mostRecentlyDeployedBasicNft = DevOpsTools
            .get_most_recent_deployment("BasicNFT", block.chainid);

        console.log("Contract");
        console.log(mostRecentlyDeployedBasicNft);
        minNftOnContract(mostRecentlyDeployedBasicNft);
    }

    function minNftOnContract(address nftContract) public {
        vm.startBroadcast();
        BasicNFT(nftContract).mintNft(PUG_URI);
        vm.stopBroadcast();
    }
}

contract MintMoodNft is Script {
    function run() external {
        console.log("ChainId \n");
        console.log(block.chainid);

        address mostRecentlyDeployedBasicNft = DevOpsTools
            .get_most_recent_deployment("MoodNft", block.chainid);

        console.log("Contract");
        console.log(mostRecentlyDeployedBasicNft);
        minNftOnContract(mostRecentlyDeployedBasicNft);
    }

    function minNftOnContract(address nftContract) public {
        vm.startBroadcast();
        MoodNft(nftContract).mintNft();
        vm.stopBroadcast();
    }
}
