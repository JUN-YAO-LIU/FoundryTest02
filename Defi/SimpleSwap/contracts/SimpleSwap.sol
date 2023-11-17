// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { ISimpleSwap } from "./interface/ISimpleSwap.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { TestERC20 } from "./test/TestERC20.sol";
import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";

contract SimpleSwap is ISimpleSwap, ERC20 {
    TestERC20 public _tokenA;
    TestERC20 public _tokenB;

    uint256 private reservesA;
    uint256 private reservesB;

    mapping(address => uint256) private reserveAOwner;
    mapping(address => uint256) private reserveBOwner;

    constructor(address tokenA, address tokenB) ERC20("give the LP Token", "LP") {
        isContractA(tokenA);
        isContractB(tokenB);

        require(tokenA !=tokenB,"SimpleSwap: TOKENA_TOKENB_IDENTICAL_ADDRESS");

        reservesA = 0;
        reservesB = 0; 

        // from -> test_constructor_tokenA_should_be_less_than_tokenB
        // assert(uint256(uint160(tokenA)) < uint256(uint160(tokenB)));
        if (uint256(uint160(tokenA)) > uint256(uint160(tokenB))) {
            _tokenB = TestERC20(tokenA);
            _tokenA = TestERC20(tokenB);
        }else{
            _tokenA = TestERC20(tokenA);
            _tokenB = TestERC20(tokenB);
        }
    }

    function addLiquidity(
        uint256 amountAIn,
        uint256 amountBIn
    ) external override returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
        require(amountAIn > 0 && amountBIn > 0, "SimpleSwap: INSUFFICIENT_INPUT_AMOUNT");
        
        if (reservesA == 0 && reservesB == 0) {
            (amountA, amountB) = (amountAIn, amountBIn);
        } else {
            uint amountBOptimal = quote(amountAIn, reservesA, reservesB);
            if (amountBOptimal <= amountBIn) {
                (amountA, amountB) = (amountAIn, amountBOptimal);
            } else {
                uint amountAOptimal = quote(amountBIn, reservesB, reservesA);
                (amountA, amountB) = (amountAOptimal, amountBIn);
            }
        }

        liquidity = Math.sqrt(amountA * amountB);

        reservesA += amountA;
        reservesB += amountB;

        _tokenA.transferFrom(msg.sender, address(this), amountA);
        _tokenB.transferFrom(msg.sender, address(this), amountB);
        mint(msg.sender, liquidity);

        emit AddLiquidity(msg.sender, amountA, amountB, liquidity);
    }

    function removeLiquidity(uint256 liquidity) external override returns (uint256 amountA, uint256 amountB) {
        require(liquidity > 0,"SimpleSwap: INSUFFICIENT_LIQUIDITY_BURNED");
        require(balanceOf(msg.sender) >= liquidity,"SimpleSwap: INSUFFICIENT_LIQUIDITY_BURNED");

        uint256 totalSupply = totalSupply();
        amountA = (liquidity * reservesA) / totalSupply;
        amountB = (liquidity * reservesB) / totalSupply;

        burn(liquidity);

        _tokenA.transfer(msg.sender,amountA);
        _tokenB.transfer(msg.sender,amountB);

        reservesA -= amountA;
        reservesB -= amountB;

        emit Transfer(address(this), address(0), liquidity);
    }

    function swap(address tokenIn, address tokenOut, uint256 amountIn) external override returns (uint256 amountOut) {
        require(address(_tokenA) == tokenIn || address(_tokenB) == tokenIn, "SimpleSwap: INVALID_TOKEN_IN");

        require(address(_tokenA) == tokenOut || address(_tokenB) == tokenOut, "SimpleSwap: INVALID_TOKEN_OUT");

        require(tokenIn != tokenOut, "SimpleSwap: IDENTICAL_ADDRESS");

        require(amountIn > 0, "SimpleSwap: INSUFFICIENT_INPUT_AMOUNT");

        if(address(_tokenA) == tokenIn){
           amountOut = amountIn * reservesB / (reservesA + amountIn);
           reservesA += amountIn;
           reservesB -= amountOut;
        }

        if(address(_tokenB) == tokenIn){
            amountOut = amountIn * reservesA / (reservesB + amountIn);
            reservesA -= amountOut;
            reservesB += amountIn;
        }

        TestERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        TestERC20(tokenOut).transfer(msg.sender, amountOut);

        emit Swap(msg.sender, tokenIn, tokenOut, amountIn, amountOut);
    }

    function getReserves() external view override returns (uint256 reserveA, uint256 reserveB) {
        reserveA = reservesA;
        reserveB = reservesB;
    }

    function getTokenA() external view override returns (address tokenA) {
        tokenA = address(_tokenA);
    }

    function getTokenB() external view override returns (address tokenB) {
        tokenB = address(_tokenB);
    }

    function mint(address account, uint256 amount) internal {
        super._mint(account, amount);
    }

    function burn(uint256 amount) internal {
       super. _burn(msg.sender,amount);
    }

    function isContractA(address _addr) private view {
        uint length;
        assembly {
            length := extcodesize(_addr)
        }
        if (length <= 0) {
            revert("SimpleSwap: TOKENA_IS_NOT_CONTRACT");
        }
    }

    function isContractB(address _addr) private view {
        uint length;
        assembly {
            length := extcodesize(_addr)
        }
        if (length <= 0) {
            revert("SimpleSwap: TOKENB_IS_NOT_CONTRACT");
        }
    }

    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        amountB = amountA * reserveB / reserveA;
    }
}
