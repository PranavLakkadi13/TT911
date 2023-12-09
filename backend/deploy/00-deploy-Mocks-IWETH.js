const { network, ethers } = require("hardhat");
const {developmentChains} = require("../helper-hardhat-config");
const {verify} = require("../utils/verify");

if (developmentChains.includes(network.name)){
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
      
      
        if (
          !developmentChains.includes(network.name) &&
          process.env.Etherscan_API_KEY
        ) {
          log("Verifying contract......");
            await verify(Hasher.address, args);
            log(
              "--------------------------------------------------------------------------"
            );
          }
      
        log("Deploying the Verifier COntract.......");
      };
      
      module.exports.tags = ["Hasher","all"];
}