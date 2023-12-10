const { network, ethers } = require("hardhat");
const {developmentChains,networkConfig,LoanPercent} = require("../helper-hardhat-config");
const {verify} = require("../utils/verify");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer } = await getNamedAccounts();
  const { deploy, log } = deployments;
  const chainId = network.config.chainId;

  const hasher = await deployments.get("Hasher");
  const veirifer = await deployments.get("Groth16Verifier");

  const args = [hasher.address,veirifer.address,"0x6C55782683dA33FA742B71f89F0dF88fFcBD6F28",LoanPercent, "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9"];

  const Tornado = await deploy("Tornado", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  // if (
  //   !developmentChains.includes(network.name) &&
  //   process.env.PolygonScan_API_KEY
  // ) {
  //   log("Verifying contract......");
  //     await verify(Tornado.address, args);
  //     log(
  //       "--------------------------------------------------------------------------"
  //     );
  //   }

  log("Deploying the Verifier COntract.......");
};

module.exports.tags = ["Tornado","all"];