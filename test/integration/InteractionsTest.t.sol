//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 1 ether;
    uint256 constant STARTING_BALANCE = 121 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFund() public {
        FundFundMe fundFundMe = new FundFundMe();

        vm.deal(address(fundFundMe), 20e18);
        fundFundMe.i_fundFundMe(address(fundMe));

        address funder = fundMe.getFunder(0);
        assertEq(funder, address(fundFundMe));
    }

    function testUserCanWithdraw() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(address(fundFundMe), 1e18);
        fundFundMe.i_fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.i_withdrawFundMe(address(fundMe));

        uint256 balanceAfter = address(fundMe).balance;
        assertEq(balanceAfter, 0, "Balance should be zero after withdrawal");
    }
}
