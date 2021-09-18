

import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { DeployFunction } from 'hardhat-deploy/types';

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deployments, getNamedAccounts, ethers } = hre;
    const { deploy, log } = deployments

    const { deployer, alice, bob } = await getNamedAccounts();

    const rewardToken = await deploy('Token', { from: deployer, log: true, args: [alice, bob] })


    await deploy('RockPaperScissors', {
        from: deployer,
        args: [10, rewardToken.address,],
        log: true,
    });
};
export default func;
func.tags = ['RockPaperScissors', "Token"];