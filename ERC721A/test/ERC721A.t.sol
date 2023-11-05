// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {JimNFTA} from "../src/JimERC721A.sol";

contract ERC721A is Test {
    JimNFTA public jimTokenA;
    address public jim = makeAddr("jim");
    address public bob = makeAddr("bob");

    function setUp() public {
        jimTokenA = new JimNFTA();
    }

    function test_mint() public {
        vm.startPrank(jim);
        jimTokenA.mint(1);
        vm.stopPrank();
        assertEq(jimTokenA.balanceOf(jim), 1);
    }

    function test_10_mint() public {
        vm.startPrank(jim);
        jimTokenA.mint(10);
        vm.stopPrank();
        assertEq(jimTokenA.balanceOf(jim), 10);
    }

    function test_transfer() public {
        vm.startPrank(jim);
        jimTokenA.mint(1);
        jimTokenA.safeTransferFrom(jim,bob,0);
        vm.stopPrank();
        assertEq(jimTokenA.ownerOf(0), bob);
    }


    function test_10_transfer() public {
        vm.startPrank(jim);
        jimTokenA.mint(10);
        for(uint8 i =0 ;i < 10;i++){
            jimTokenA.safeTransferFrom(jim,bob,i);
        }
        vm.stopPrank();
        assertEq(jimTokenA.balanceOf(bob), 10);
    }

    function test_approve() public {
        vm.startPrank(jim);
        jimTokenA.mint(10);
        jimTokenA.approve(bob,1);
        vm.stopPrank();
        assertEq(jimTokenA.getApproved(1), bob);
    }

    function test_10_approve() public {
        vm.startPrank(jim);
        jimTokenA.mint(10);
        for(uint8 i =0 ;i < 10;i++){
            jimTokenA.approve(bob,i);
        }
        vm.stopPrank();
        assertEq(jimTokenA.getApproved(1), bob);
    }
}
