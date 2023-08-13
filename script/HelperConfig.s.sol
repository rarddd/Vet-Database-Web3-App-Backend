// SPDX-License-Identifier: MIT

/* Deploy mocks when we're on anvil local chain
 * Keep track of contract addresses across different chains
 * Sepolia vrfCoordinator contract address = A
 * Arbitrum Mainnet vrfCoordinator contract address = B
 */

pragma solidity 0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    // Will fetch/configure respective contract addresses & params dependent on network to network basis
    // If using local Anvil testnet: utilize mock contracts
    struct NetworkConfig {
        string name;
        string symbol;
        address deployerkey;
    }

    uint8 public constant DECIMALS = 8;
    uint256 public constant BASE_CHAIN_ID = 8453;
    uint256 public constant BASE_GORELI_CHAIN_ID = 84531;
    uint256 public constant OPTIMISM_CHAIN_ID = 10;
    uint256 public constant OPTIMISM_KOVAN_CHAIN_ID = 69;
    uint256 public constant DEAFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    // If using local Anvil testnet: utilize mock contracts

    constructor() {
        if (block.chainid == BASE_CHAIN_ID) {} else if (
            block.chainid == BASE_GORELI_CHAIN_ID
        ) {} else if (block.chainid == OPTIMISM_CHAIN_ID) {} else
            (block.chainid == OPTIMISM_KOVAN_CHAIN_ID);
    }

    function getBaseNetworkConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({deployerKey: vm.envUint("PUBLIC_PRIVATE_KEY")});
    }

    function getBaseGoreliNetworkConfig()
        public
        view
        returns (NetworkConfig memory)
    {
        // VRFCoordinatorV2Interace contract address
        return
            NetworkConfig({
                name: "PetNFT",
                symbol: "PT",
                deployerKey: vm.envUint("PUBLIC_PRIVATE_KEY")
            });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // Ensures that a mock vrfCoordinator address hasn't been created yet
        if (activeNetworkConfig.vrfCoordinatorV2 != address(0)) {
            return activeNetworkConfig;
        }
        // mock vrfCoordinator address

        // 1. Deploy mock contracts
        // 2. Return mock contract addresses

        uint96 baseFee = 0.025 ether; // 0.25 LINK
        uint96 gasPriceLink = 1e9; // 1gwei of LINK

        vm.startBroadcast();
        VRFCoordinatorV2Mock vrfCoordinatorMock = new VRFCoordinatorV2Mock(
            baseFee,
            gasPriceLink
        );
        // this makes a mock instance of the link token in
        LinkToken link = new LinkToken();
        vm.stopBroadcast();

        return
            NetworkConfig({
                vrfCoordinatorV2: address(vrfCoordinatorMock),
                ticketPrice: 0.02 ether,
                interval: 120,
                // 30 gwei Key Hash == gasLane
                gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
                subscriptionId: 0, // Our script will add thiss
                requestConfirmations: 3,
                callBackGasLimit: 500000, // 5
                link: address(link),
                deployerKey: DEAFAULT_ANVIL_PRIVATE_KEY
            });
    }
}
