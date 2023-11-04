// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol"; 
import "./ERC721A.sol";

contract JimNFT is ERC721{
    uint public newItemId = 1;

    constructor() ERC721("Jim published his token,call JT.", "JT") {
    }

    function mint() public {
        _safeMint(msg.sender, newItemId);
        newItemId += 1;
    }
}

contract JimNFTA is ERC721A{

    constructor() ERC721A("Jim published his first ERC721A token,call JAT.", "JAT") {
    }

    function mint(uint256 amount) public {
        _safeMint(msg.sender, amount);
    }
}