const { network, ethers } = require("hardhat");
const {developmentChains} = require("../helper-hardhat-config");
const {verify} = require("../utils/verify");

module.exports = async ({ getNamedAccounts, deployments }) => {
        const { deployer } = await getNamedAccounts();
        const { deploy, log } = deployments;
        const chainId = network.config.chainId;
      
        const args = [];
      
        const Hasher = await deploy("Hasher", {
          from: deployer,
          args: [],
          log: true,
          waitConfirmations: network.config.blockConfirmations || 1,
        });
    
    }
      
module.exports.tags = ["Hasher","all"];