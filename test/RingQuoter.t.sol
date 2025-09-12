// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {RingQuoter} from "../src/RingQuoter.sol";
import {Test, console2} from "forge-std/Test.sol";

contract RingQuoterTest is Test {
    RingQuoter public quoter;
    address constant RingPool = 0x44deaF11892D189D1D1c0CCF3bdE7a6CCEa24405;

    function setUp() public {
        vm.createSelectFork("https://eth.llamarpc.com");
        quoter = new RingQuoter();
    }

    function testGetPoolTokenBalance() public {
        (uint256 token0Balance, uint256 token1Balance, uint256 underlyingAsset0Balance, uint256 underlyingAsset1Balance) = quoter.getPoolTokenBalance(RingPool);
        console2.log("token0Balance", token0Balance);
        console2.log("token1Balance", token1Balance);
        console2.log("underlyingAsset0Balance", underlyingAsset0Balance);
        console2.log("underlyingAsset1Balance", underlyingAsset1Balance);
    }

}
