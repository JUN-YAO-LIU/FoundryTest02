// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {JimNFT} from "../src/JimERC721A.sol";

contract ERC721Jim is Test {
    JimNFT public jimToken;
    address public jim = makeAddr("jim");
    address public bob = makeAddr("bob");

    function setUp() public {
        jimToken = new JimNFT();
    }

    function test_mint() public {
        vm.startPrank(jim);
        jimToken.mint();
        vm.stopPrank();
        assertEq(jimToken.balanceOf(jim), 1);
    }

    function test_10_mint() public {
        vm.startPrank(jim);
        for(uint8 i =0 ;i < 10;i++){
            jimToken.mint();
        }
        vm.stopPrank();
        assertEq(jimToken.balanceOf(jim), 10);
    }

    function test_transfer() public {
        vm.startPrank(jim);
        jimToken.mint();
        jimToken.safeTransferFrom(jim,bob,1);
        vm.stopPrank();
        assertEq(jimToken.ownerOf(1), bob);
    }

    function test_10_transfer() public {
        vm.startPrank(jim);
         for(uint8 i =0 ;i < 10;i++){
            jimToken.mint();
            jimToken.safeTransferFrom(jim,bob,1+i);
        }
        vm.stopPrank();
        assertEq(jimToken.balanceOf(bob), 10);
    }

    function test_approve() public {
        vm.startPrank(jim);
        jimToken.mint();
        jimToken.approve(bob,1);
        vm.stopPrank();
        assertEq(jimToken.getApproved(1), bob);
    }

    function test_10_approve() public {
        vm.startPrank(jim);
        for(uint8 i =0 ;i < 10;i++){
            jimToken.mint();
            jimToken.approve(bob,i+1);
        }
        vm.stopPrank();
        assertEq(jimToken.getApproved(1), bob);
    }
}
