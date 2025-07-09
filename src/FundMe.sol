//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error NotOwner();
error NotEnoughFunding();
error TransactionNotSend();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MIN_USD = 5e18;
    address private immutable i_owner;

    address[] private s_funders;
    mapping(address Funders => uint256 EthAmount) private s_FunderToEthAmount;

    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    modifier ownerVerification() {
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    function fund() public payable {
        if (msg.value.getConversionRate(s_priceFeed) < MIN_USD) {
            revert NotEnoughFunding();
        }
        if (s_FunderToEthAmount[msg.sender] == 0) {
            s_funders.push(msg.sender);
        }
        s_FunderToEthAmount[msg.sender] += msg.value;
    }

    function withdraw() public ownerVerification {
        uint256 funderlength = s_funders.length;

        for (uint256 funderIndex = 0; funderIndex < funderlength; funderIndex++) {
            s_FunderToEthAmount[s_funders[funderIndex]] = 0;
        }

        s_funders = new address[](0);

        (bool sucess,) = payable(msg.sender).call{value: address(this).balance}("");

        if (!sucess) revert TransactionNotSend();
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    //Getter Functions
    function getAddressToAmountFunded(address funder) external view returns (uint256) {
        return s_FunderToEthAmount[funder];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
