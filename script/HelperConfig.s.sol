//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else if (block.chainid == 5) {
            activeNetworkConfig = getMonadEthConfig();
        } else {
            activeNetworkConfig = getAndCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() internal pure returns (NetworkConfig memory) {
        return NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    }

    function getMainnetEthConfig() internal pure returns (NetworkConfig memory) {
        return NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
    }

    function getMonadEthConfig() internal pure returns (NetworkConfig memory) {
        return NetworkConfig({priceFeed: 0x0c76859E85727683Eeba0C70Bc2e0F5781337818});
    }

    function getAndCreateAnvilEthConfig() internal returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        uint8 DECIMALS = 8;
        int256 ETH_PRICE = 2000e8;
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, ETH_PRICE);
        vm.stopBroadcast();

        return NetworkConfig({priceFeed: address(mockPriceFeed)});
    }
}
