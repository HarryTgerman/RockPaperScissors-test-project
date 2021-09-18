


import { expect } from "./chai-setup";

import { ethers, deployments, getNamedAccounts } from 'hardhat';

describe("RockPaperScissors contract", async function () {
  let rockPaperScissors: any;
  let token: any;

  const { deployer, alice, bob } = await getNamedAccounts();

  beforeEach(async () => {
    await deployments.fixture(["RockPaperScissors"]);

    const RockPaperScissors = await deployments.get('RockPaperScissors')


    rockPaperScissors = await ethers.getContractAt('RockPaperScissors', RockPaperScissors.address)

  })


  it("Check deployment parameter", async function () {
    expect(await rockPaperScissors.token()).to.equal(token.address);
    expect(await rockPaperScissors.entranceFee()).to.equal(10);
  });


  // setPriceFeedContract
  // stakeTokens
  // addAllowedTokens
  // issueTokens
  // claimTokens
  // unstakeTokens
});