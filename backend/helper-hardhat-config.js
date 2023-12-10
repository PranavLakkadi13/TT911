const networkConfig = {
    default: {
      name: "hardhat",
      keepersUpdateInterval: "30",
    },
    31337: {
      
    },
    11155111: {
      name: "sepolia",
      weth: "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9"
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