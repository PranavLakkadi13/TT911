const networkConfig = {
    default: {
      name: "hardhat",
      keepersUpdateInterval: "30",
    },
    31337: {
      
    },
    11155111: {
      name: "sepolia",
      weth: "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9",
      hasher: "0xe5c1534D000b5526771e1568708E0A9F8f71Ba6D",
      verifier: "0x0cb6873cb9ed6015ab18ef98c13534daccb9c53d",
      tornado: "0x8cbC3C78b38f82933c360348739afD7ef0CD21b9",
    },
    1: {
      name: "mainnet",
      keepersUpdateInterval: "30",
    },
    
  };
  
  const developmentChains = ["hardhat", "localhost"];
  const VERIFICATION_BLOCK_CONFIRMATIONS = 6;
  const LoanPercent = 1e15
  
  module.exports = {
    networkConfig,
    developmentChains,
    VERIFICATION_BLOCK_CONFIRMATIONS,
    LoanPercent,
  };