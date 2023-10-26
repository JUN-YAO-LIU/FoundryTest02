// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "solmate/tokens/ERC20.sol";
import { USDC2, IERC20 } from "../src/USDC2.sol";
import { UpgradeableProxy } from "../src/UpgradeableProxy.sol";

contract USDC2Test is Test{
   address public owner;
   address public jim = makeAddr("jim");

   USDC2 usdc2;
   UpgradeableProxy upgradeProxy;
   address Proxy;
   USDC2 proxyUSDC;

   function setUp()public{
      owner = 0x807a96288A1A408dBC13DE2b1d087d10356395d2;
      Proxy = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
   }

   // admin 0x807a96288a1a408dbc13de2b1d087d10356395d2
   function testUpgradeableUSDC() public {
      uint256 forkId = vm.createFork(
            "https://eth-mainnet.g.alchemy.com/v2/k-sz4T_Vr7gOvMk-OHpUTzlAiU9VDs3q",
            18427972);
      vm.selectFork(forkId);
      vm.startPrank(owner);

      // 這是建立合約的寫法，如果寫在setup裡會，這邊會讀不到。
      usdc2 = new USDC2();

      console.log(owner);
      console.log(address(usdc2));
      
      // OK
      (bool success, ) = address(Proxy)
      .call(abi.encodeWithSignature("upgradeTo(address)",address(usdc2)));

      // OK
      (bool success1, bytes memory data) = address(Proxy)
      .call(abi.encodeWithSignature("admin()"));
      
      (bool success2, ) = address(Proxy)
      .call(abi.encodeWithSignature("mint(uint256)",10));

      vm.stopPrank();
      assertEq(block.number, 18427972);
      assertEq(IERC20(address(usdc2)).balanceOf(owner),10);
   }
}