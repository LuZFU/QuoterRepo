// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface ITokenHelper {
    function getTokenInfo(
        address token
    )
        external
        view
        returns (
            uint256 version,
            address tokenManager,
            address quote,
            uint256 lastPrice,
            uint256 tradingFeeRate,
            uint256 minTradingFee,
            uint256 launchTime,
            uint256 offers,
            uint256 maxOffers,
            uint256 funds,
            uint256 maxFunds,
            bool liquidityAdded
        );
}
interface ITokenSwap {
    function _fees(address) external view returns (uint);
}
interface IFactory {
    function getPool(address, address, uint24) external view returns (address);
    function poolByPair(address, address) external view returns (address);
}


contract FourMemeTokenQuoter {
    address public constant TOKEN_MANAGER = 0x5c952063c7fc8610FFDB798152D69F0B9550762b;
    address public constant TOKEN_SWAP = 0x350A94c918f7A0C8d108ba90f1b242B0143572B9;
    address public constant TOKEN_HELPER = 0xF251F83e40a78868FcfA3FA4599Dad6494E46034;

    address public constant THENA = 0xF4C8E32EaDEC4BFe97E0F595AdD0f4450a863a11;
    address public constant WETH = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public constant PANCAKE_QUOTER = 0xB048Bbc1Ee6b733FFfCFb9e9CeF7375518e25997;
    address public constant PANCAKE_FACTORY = 0x0BFbCF9fa4f9C56B0F40a671Ad40E0805A091865;
    address public constant THENA_FACTORY = 0x306F06C147f064A010530292A1EB6737c3e378e4;

    // Query token version
    function getTokenVersion(address token) external view returns (uint256 version) {
        (uint256 _version, , , , , , , , , , , ) = ITokenHelper(TOKEN_HELPER).getTokenInfo(token);
        return _version;
    }
    
    // Query the pool address corresponding to the paired token
    function getPoolAddress(address token) public view returns (address pool) {
        (uint256 version, , address quoteToken, , , , , , , , , ) = ITokenHelper(TOKEN_HELPER).getTokenInfo(token);
        require(version == 2, "Only version 2 supported");
        require(quoteToken != WETH, "Quote token cannot be BNB");
        
        uint24 fee = uint24(ITokenSwap(TOKEN_SWAP)._fees(quoteToken));
        
        if (quoteToken == THENA) {
            pool = IFactory(THENA_FACTORY).poolByPair(quoteToken, WETH);
        } else {
            require(fee > 0, "Invalid fee rate");
            pool = IFactory(PANCAKE_FACTORY).getPool(quoteToken, WETH, fee);
        }
        
        require(pool != address(0), "Pool not found");
        return pool;
    }
    
    // Query the fee rate of the paired token
    function getFeeRate(address quoteToken) public view returns (uint24) {
        return uint24(ITokenSwap(TOKEN_SWAP)._fees(quoteToken));
    }
    
    // Get complete token information
    function getTokenInfo(address token) external view returns (
        uint256 version,
        address quoteToken,
        address poolAddress,
        uint24 feeRate
    ) {
        (version, , quoteToken, , , , , , , , , ) = ITokenHelper(TOKEN_HELPER).getTokenInfo(token);
        
        if (version == 2 && quoteToken != WETH) {
            feeRate = getFeeRate(quoteToken);
            if (feeRate > 0 || quoteToken == THENA) {
                poolAddress = getPoolAddress(token);
            }
        }
        
        return (version, quoteToken, poolAddress, feeRate);
    }
}
