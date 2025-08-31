// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {IMiniAMM, IMiniAMMEvents} from "./IMiniAMM.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Add as many variables or functions as you would like
// for the implementation. The goal is to pass `forge test`.
contract MiniAMM is IMiniAMM, IMiniAMMEvents {
    uint256 public k = 0;
    uint256 public xReserve = 0;
    uint256 public yReserve = 0;

    address public tokenX;
    address public tokenY;

    // implement constructor
    constructor(address _tokenX, address _tokenY) {
        require(_tokenX != address(0), "tokenX cannot be zero address");
        require(_tokenY != address(0), "tokenY cannot be zero address");
        require(_tokenX != _tokenY, "Tokens must be different");

        if(_tokenX > _tokenY){
            tokenX = _tokenY;
            tokenY = _tokenX;
        }else{
            tokenX = _tokenX;
            tokenY = _tokenY;
        }
    }

    // add parameters and implement function.
    // this function will determine the initial 'k'.
    function _addLiquidityFirstTime(uint256 _xAmountIn, uint256 _yAmountIn) internal {
        require(xReserve == 0 && yReserve == 0,"It's not first time");
        
        _transferTokenToLiquidityPool(_xAmountIn, _yAmountIn);

        k = xReserve * yReserve;
    }

    // add parameters and implement function.
    // this function will increase the 'k'
    // because it is transferring liquidity from users to this contract.
    function _addLiquidityNotFirstTime(uint256 _xAmountIn, uint256 _yAmountIn) internal {
        require(xReserve != 0 && yReserve != 0, "This pair is first time");
        
        _transferTokenToLiquidityPool(_xAmountIn, _yAmountIn);

        k = xReserve * yReserve;
    }

    // complete the function
    function addLiquidity(uint256 xAmountIn, uint256 yAmountIn) external {
        require(xAmountIn > 0, "Amounts must be greater than 0");
        require(yAmountIn > 0, "Amounts must be greater than 0");
        if (k == 0) {
            // add params
            _addLiquidityFirstTime(xAmountIn, yAmountIn);
        } else {
            // add params
            _addLiquidityNotFirstTime(xAmountIn, yAmountIn);
        }

        emit AddLiquidity(xAmountIn, yAmountIn);
    }

    function _transferTokenToLiquidityPool(uint256 _xAmountIn, uint256 _yAmountIn) internal{
        IERC20(tokenX).transferFrom(msg.sender, address(this), _xAmountIn);
        IERC20(tokenY).transferFrom(msg.sender, address(this), _yAmountIn);

        xReserve = IERC20(tokenX).balanceOf(address(this));
        yReserve = IERC20(tokenY).balanceOf(address(this));
    }

    // complete the function
    function swap(uint256 xAmountIn, uint256 yAmountIn) external {
        require(xReserve != 0 || yReserve != 0, "No liquidity in pool");
        require(xAmountIn != 0 || yAmountIn != 0, "Must swap at least one token");
        require(xAmountIn > 0 && yAmountIn ==0 || yAmountIn > 0 && xAmountIn == 0, "Can only swap one direction at a time");

        if(xAmountIn == 0){
            uint256 xAmountOut = calculateXAmountOut(yAmountIn);
            IERC20(tokenY).approve(address(this), yAmountIn);
            IERC20(tokenX).approve(address(this), xAmountOut);

            IERC20(tokenY).transferFrom(msg.sender, address(this), yAmountIn);
            IERC20(tokenX).transferFrom(address(this), msg.sender, xAmountOut);

            xReserve = IERC20(tokenX).balanceOf(address(this));
            yReserve = IERC20(tokenY).balanceOf(address(this));

        }else if(yAmountIn == 0){
            uint256 yAmountOut = calculateYAmountOut(xAmountIn);
            IERC20(tokenX).approve(address(this), xAmountIn);
            IERC20(tokenY).approve(address(this), yAmountOut);

            IERC20(tokenX).transferFrom(msg.sender, address(this), xAmountIn);
            IERC20(tokenY).transferFrom(address(this), msg.sender, yAmountOut);

            xReserve = IERC20(tokenX).balanceOf(address(this));
            yReserve = IERC20(tokenY).balanceOf(address(this));
            emit Swap(xAmountIn, yAmountOut);
        }

        
    }

    function calculateXAmountOut(uint256 _yAmountIn) internal view returns(uint256){
        require(yReserve > _yAmountIn, "Insufficient liquidity");

        return xReserve - (k / (yReserve + _yAmountIn)); 
    }

    function calculateYAmountOut(uint256 _xAmountIn) internal view returns(uint256){
        require(xReserve > _xAmountIn, "Insufficient liquidity");

        return yReserve - (k / (xReserve + _xAmountIn)); 
    }


}
