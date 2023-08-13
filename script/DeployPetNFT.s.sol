// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";
import {PetNFT} from "../src/PetNFT.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

// import {FundSubScription} from "./test/integration/Interactions.sol";
// import {AddConsumer} from "./test/integration/Interactions.sol";

contract DeployPetNFT is Script {
    function run() external returns (PetNFT, HelperConfig) {
        // Helper config always before startBroadcast
        HelperConfig helperConfig = new HelperConfig();
        (address petName, address symbol, uint256 deployerKey) = helperConfig
            .activeNetworkConfig();

        vm.startBroadcast(deployerKey);
        PetNFT petNFT = new PetNFT(petName, symbol);
        vm.stopBroadcast();

        addConsumer.addConsumer(
            address(raffle),
            vrfCoordinatorV2,
            subscriptionId,
            deployerKey
        );

        return (petNFT, helperConfig);
    }
}
