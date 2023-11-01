// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import { MultiSigWallet } from "./MultiSigWallet.sol";

contract MultiSigWalletV2 is MultiSigWallet{

    constructor(address[3] memory _owners) MultiSigWallet(_owners){
    }

    function initialize(address[3] memory _owners)external {
    }

    // not use override.
    function updateOwner(address owner) external virtual {
      adminOwner = owner;
    }

    function cancelTransaction()external {
        transactions.pop();
    }

}