// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Proxy } from "./Proxy.sol";
import { BasicProxy } from "./BasicProxy.sol";

contract UpgradeableProxy is BasicProxy {
  // TODO:
  // 1. inherit or copy the code from BasicProxy
  constructor(address impl) BasicProxy(impl) {
  }

  // 2. add upgradeTo function to upgrade the implementation contract
  function upgradeTo(address newImplementation) external {
    _imp = newImplementation;
  }

  // 3. add upgradeToAndCall, which upgrade the implemnetation contract and call the init function again
  function upgradeToAndCall(address newImplementation,bytes calldata data) external {
    _imp = newImplementation;

    // 這邊沒有initialize 所以可以自己寫一個讓他有initialize
    (bool success, ) = _imp.delegatecall(data);
    require(success,"upgradeproxy fail.");
  }
}