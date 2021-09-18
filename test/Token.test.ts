


import { expect } from "./chai-setup";

import { ethers, deployments, getNamedAccounts } from 'hardhat';

describe("Token contract", async function () {
    let token: any;

    const { deployer, alice, bob } = await getNamedAccounts();

    beforeEach(async () => {
        await deployments.fixture(["Token"]);
        const Token = await deployments.get('Token')
        token = await ethers.getContractAt('Token', Token.address)
        console.log(Token, token, deployments)

    })


    it("Check deployment parameter", async function () {
        expect(await token.balanceOf(alice)).to.equal(ethers.utils.formatEther(10));
        expect(await token.balanceOf(bob)).to.equal(ethers.utils.formatEther(10));
    });


    // setPriceFeedContract
    // stakeTokens
    // addAllowedTokens
    // issueTokens
    // claimTokens
    // unstakeTokens
});