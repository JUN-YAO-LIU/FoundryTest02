// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IUniswapV2Pair } from "v2-core/interfaces/IUniswapV2Pair.sol";
import { IUniswapV2Callee } from "v2-core/interfaces/IUniswapV2Callee.sol";
import { TestWETH9 } from "../contracts/test/TestWETH9.sol";
import { TestERC20 } from "../contracts/test/TestERC20.sol";

// This is a practice contract for flash swap arbitrage
contract Arbitrage is IUniswapV2Callee, Ownable {

    struct CallbackData {
        uint256 repayUSDCAmount;
        uint256 earnUSDCAmount;
        address priceHigherPool;
        address priceLowerPool;
    }

    //
    // EXTERNAL NON-VIEW ONLY OWNER
    //

    function withdraw() external onlyOwner {
        (bool success, ) = msg.sender.call{ value: address(this).balance }("");
        require(success, "Withdraw failed");
    }

    function withdrawTokens(address token, uint256 amount) external onlyOwner {
        require(IERC20(token).transfer(msg.sender, amount), "Withdraw failed");
    }

    //
    // EXTERNAL NON-VIEW
    //

    function uniswapV2Call(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external override {
        // TODO
        CallbackData memory callbackData  = abi.decode(data,(CallbackData));
        address ethAddr = IUniswapV2Pair(callbackData.priceHigherPool).token0();
        address usdcAddr = IUniswapV2Pair(callbackData.priceLowerPool).token1();

        // wETH swap USDC
        // SushiPool
        IERC20(ethAddr).transfer(callbackData.priceHigherPool,amount0);
        IUniswapV2Pair(callbackData.priceHigherPool).swap(
            0,
            callbackData.earnUSDCAmount,
            sender,
            ""
        );

        IERC20(usdcAddr).transfer(callbackData.priceLowerPool,callbackData.repayUSDCAmount);
    }

    // Method 1 is
    //  - borrow WETH from lower price pool
    //  - swap WETH for USDC in higher price pool
    //  - repay USDC to lower pool
    // Method 2 is
    //  - borrow USDC from higher price pool
    //  - swap USDC for WETH in lower pool
    //  - repay WETH to higher pool
    // for testing convenient, we implement the method 1 here
    function arbitrage(address priceLowerPool, address priceHigherPool, uint256 borrowETH) external {
        // TODO

        // 計算需要還多少USDC給priceLowerPool ETH USDC
        (uint256 _reserveETH_Low, uint256 _reserveUSDC_Low,) = IUniswapV2Pair(priceLowerPool).getReserves();
        (uint256 _reserveETH_High, uint256 _reserveUSDC_High,) = IUniswapV2Pair(priceHigherPool).getReserves();

        uint256 bWETH = borrowETH;
        uint256 repayUSDCAmount = _getAmountIn(bWETH,_reserveUSDC_Low,_reserveETH_Low);
        uint256 earnUSDCAmount = _getAmountOut(bWETH,_reserveETH_High,_reserveUSDC_High);

        CallbackData memory callbckData = CallbackData(repayUSDCAmount,earnUSDCAmount,priceHigherPool,priceLowerPool);

        // 換出USDC
        IUniswapV2Pair(priceLowerPool).swap(
            bWETH,
            0,
            address(this),
            abi.encode(callbckData)
        );
    }

    //
    // INTERNAL PURE
    //

    // copy from UniswapV2Library
    function _getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountIn) {
        require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        uint256 numerator = reserveIn * amountOut * 1000;
        uint256 denominator = (reserveOut - amountOut) * 997;
        amountIn = numerator / denominator + 1;
    }

    // copy from UniswapV2Library
    function _getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountOut) {
        require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        uint256 amountInWithFee = amountIn * 997;
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = reserveIn * 1000 + amountInWithFee;
        amountOut = numerator / denominator;
    }
}
