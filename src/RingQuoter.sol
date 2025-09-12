// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function decimals() external view returns (uint8);
}

interface ISwapV2Pair {
    function token0() external view returns (address);
    function token1() external view returns (address);
}

interface IFewWrappedToken {
    function token() external view returns (address);
}

contract RingQuoter {
    function getPoolTokenBalance(
        address pool
    )
        external
        view
        returns (
            uint256 token0Balance,
            uint256 token1Balance,
            uint256 underlyingAsset0Balance,
            uint256 underlyingAsset1Balance
        )
    {
        address token0 = ISwapV2Pair(pool).token0();
        address token1 = ISwapV2Pair(pool).token1();
        address underlyingAsset0 = IFewWrappedToken(token0).token();
        address underlyingAsset1 = IFewWrappedToken(token1).token();
        token0Balance = IERC20(token0).balanceOf(pool);
        token1Balance = IERC20(token1).balanceOf(pool);
        underlyingAsset0Balance = IERC20(underlyingAsset0).balanceOf(token0);
        underlyingAsset1Balance = IERC20(underlyingAsset1).balanceOf(token1);

        return (
            token0Balance,
            token1Balance,
            underlyingAsset0Balance,
            underlyingAsset1Balance
        );
    }
}
