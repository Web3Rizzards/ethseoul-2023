import 'dotenv/config';

import { ethers } from 'hardhat';

module.exports = async ({ getNamedAccounts, deployments, getChainId }: any) => {
  const { deploy, read, execute } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  let WORLD_ID = ''; // TODO
  let APP_ID = ''; // TODO
  let ACTION_ID = ''; // TODO

  let contract = await deploy('Contract', {
    from: deployer,
    log: true,
    args: [WORLD_ID, APP_ID, ACTION_ID],
  });
};

module.exports.tags = ['Contract'];
