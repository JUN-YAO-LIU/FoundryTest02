// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 請假裝你是 USDC 的 Owner，嘗試升級 usdc，並完成以下功能
// 製作一個白名單
// 只有白名單內的地址可以轉帳
// 白名單內的地址可以無限 mint token
// 如果有其他想做的也可以隨時加入
// https://www.twblogs.net/a/5eec3685fcc715ab3d91539b

//  ERC20 interface
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

// 其中一個作法是，按照他發布的合約的slot位置進行部署。

contract USDC2 is IERC20{
  
  bytes32 private _proxyImp;
  bytes32 private _proxyAdmin;
  bytes32 private _gap;
  mapping(address => bool) public whiteList;
  uint public totalSupply;
  mapping(address => uint) public balanceOf;
  mapping(address => mapping(address => uint)) public allowance;
  string public name = "USD Coin";
  string public symbol = "USDC";
  uint8 public decimals = 18;

  constructor() {}

  function initialize() public {}

  function transfer(address recipient, uint amount) external returns (bool) {
    require(whiteList[msg.sender],"not in the white list.");
    balanceOf[msg.sender] -= amount;
    balanceOf[recipient] += amount;
    emit Transfer(msg.sender, recipient, amount);
    return true;
  }

  function approve(address spender, uint amount) external returns (bool) {
    require(whiteList[msg.sender],"not in the white list.");
    allowance[msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);
    return true;
  }

  function transferFrom(
    address sender,
    address recipient,
    uint amount
  ) external returns (bool) {
    require(whiteList[msg.sender],"not in the white list.");
    require(allowance[sender][msg.sender] > 0,"not in the white list.");

    allowance[sender][msg.sender] -= amount;
    balanceOf[sender] -= amount;
    balanceOf[recipient] += amount;

    emit Transfer(sender, recipient, amount);
    return true;
  }

  function mint(uint amount) external returns (bool) {
    require(whiteList[msg.sender],"not in the white list.");

    totalSupply += amount;
    balanceOf[msg.sender] += amount;

    emit Transfer(address(this), msg.sender, amount);
    return true;
  }

  function setWhtieList(address whiteMan) external {
    whiteList[whiteMan] = true;
  }

  function setFalseWhtieList(address whiteMan) external {
    whiteList[whiteMan] = false;
  }
}