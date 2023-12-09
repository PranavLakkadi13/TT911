const { network, ethers } = require("hardhat");
const {developmentChains} = require("../helper-hardhat-config");
const {verify} = require("../utils/verify");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer } = await getNamedAccounts();
  const { deploy, log } = deployments;
  const chainId = network.config.chainId;

  const hasher = await deployments.get("Hasher");
  const veirifer = await deployments.get("Groth16Verifier");

  const args = [hasher.address,veirifer.address];

  const Tornado = await deploy("Tornado", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  if (
    !developmentChains.includes(network.name) &&
    process.env.Etherscan_API_KEY
  ) {
    log("Verifying contract......");
      await verify(Tornado.address, args);
      log(
        "--------------------------------------------------------------------------"
      );
    }

  log("Deploying the Verifier COntract.......");
};

module.exports.tags = ["Tornado","all"];