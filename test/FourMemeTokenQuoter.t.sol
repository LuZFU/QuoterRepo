// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {FourMemeTokenQuoter} from "../src/FourMemeTokenQuoter.sol";

contract FourMemeTokenQuoterTest is Test {
    FourMemeTokenQuoter public quoter;
    
    address public constant TOKEN_MANAGER = 0x5c952063c7fc8610FFDB798152D69F0B9550762b;
    address public constant TOKEN_SWAP = 0x350A94c918f7A0C8d108ba90f1b242B0143572B9;
    address public constant TOKEN_HELPER = 0xF251F83e40a78868FcfA3FA4599Dad6494E46034;

    address public constant THENA = 0xF4C8E32EaDEC4BFe97E0F595AdD0f4450a863a11;
    address public constant WETH = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public constant PANCAKE_QUOTER = 0xB048Bbc1Ee6b733FFfCFb9e9CeF7375518e25997;
    address public constant PANCAKE_FACTORY = 0x0BFbCF9fa4f9C56B0F40a671Ad40E0805A091865;
    address public constant THENA_FACTORY = 0x306F06C147f064A010530292A1EB6737c3e378e4;

    
    address constant TestToken = 0xb15EeE57E3AcC00ab15cCA0B65C2b5d0dA154444;
    address constant ThenaToken = 0xbf141E43c961A8a35930b15722923fb39bDd4444;

    function setUp() public {
        // Fork BSC mainnet for realistic testing
        vm.createSelectFork("https://bsc.blockrazor.xyz");
        
        // Deploy the quoter contract
        quoter = new FourMemeTokenQuoter();
    }
    
    function test_getTokenInfo_NormalToken() public {
        (uint256 version, address quoteToken, address poolAddress, uint24 feeRate) = quoter.getTokenInfo(TestToken);
        console2.log("version", version);
        console2.log("quoteToken", quoteToken);
        console2.log("poolAddress", poolAddress);
        console2.log("feeRate", feeRate);
        assert(version == 2);
        assert(quoteToken == 0x8d0D000Ee44948FC98c9B98A4FA4921476f08B0d);
        assert(poolAddress == 0x4a3218606AF9B4728a9F187E1c1a8c07fBC172a9);
    }

    function test_getTokenInfo_ThenaToken() public {
        (uint256 version, address quoteToken, address poolAddress, uint24 feeRate) = quoter.getTokenInfo(ThenaToken);
        console2.log("version", version);
        console2.log("quoteToken", quoteToken);
        console2.log("poolAddress", poolAddress);
        console2.log("feeRate", feeRate);
    }
}
