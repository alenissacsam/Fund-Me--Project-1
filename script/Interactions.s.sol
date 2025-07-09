//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant FUND_AMOUNT = 1e18;

    function i_fundFundMe(address mostRecentlyDepolyed) public {
        FundMe(payable(mostRecentlyDepolyed)).fund{value: 1 ether}();
        console.log("Funded FundMe with %s by %s", FUND_AMOUNT, msg.sender);
    }

    function run() external {
        address mostRecentlyDepolyed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        i_fundFundMe(mostRecentlyDepolyed);
        console.log(mostRecentlyDepolyed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    function i_withdrawFundMe(address mostRecentlyDepolyed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDepolyed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDepolyed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        i_withdrawFundMe(mostRecentlyDepolyed);
    }
}
