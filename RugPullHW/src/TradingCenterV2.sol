// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

// TODO: Try to implement TradingCenterV2 here
contract TradingCenterV2 {
    bool private initialized;
    function initialize() public {
        require(!initialized, "Contract instance has already been initialized");
        initialized = true;
        x = _x;
    }
}