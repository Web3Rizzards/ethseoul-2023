import 'dotenv/config';

import { ethers } from 'hardhat';

module.exports = async ({ getNamedAccounts, deployments, getChainId }: any) => {
  const { deploy, read, execute } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  let WORLD_ID = '0xABB70f7F39035586Da57B3c8136035f87AC0d2Aa'; // TODO
  let APP_ID = 'app_staging_80251b57de090b576b3c8c1d0eab9cfd'; // TODO
  let ACTION_ID = 'Sign In WorldID'; // TODO

  let contract = await deploy('Contract', {
    from: deployer,
    log: true,
    args: [WORLD_ID, APP_ID, ACTION_ID],
  });
};

module.exports.tags = ['Contract'];
