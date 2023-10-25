// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

// �а��˧A�O USDC �� Owner�A���դɯ� usdc�A�ç����H�U�\��
// �s�@�@�ӥզW��
// �u���զW�椺���a�}�i�H��b
// �զW�椺���a�}�i�H�L�� mint token
// �p�G����L�Q�����]�i�H�H�ɥ[�J
// https://www.twblogs.net/a/5eec3685fcc715ab3d91539b

//  erc20 interface
interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract RugPull2{

    address[] public whiteList;

    function initialize() public {

    }
 
}