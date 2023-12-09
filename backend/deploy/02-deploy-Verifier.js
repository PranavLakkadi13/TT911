const { network, ethers } = require("hardhat");
const {developmentChains} = require("../helper-hardhat-config");
const {verify} = require("../utils/verify");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer } = await getNamedAccounts();
  const { deploy, log } = deployments;
  const chainId = network.config.chainId;

  const args = [];

  const Groth16Verifier = await deploy("Groth16Verifier", {
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
      await verify(Groth16Verifier.address, args);
      log(
        "--------------------------------------------------------------------------"
      );
    }

  log("Deploying the Verifier COntract.......")
};

module.exports.tags = ["Groth16Verifier","all"];