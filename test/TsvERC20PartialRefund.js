const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");

describe("TsvERC20PartialRefund", function () {
    async function deployOneYearLockFixture() {  
      const [owner, otherAccount] = await ethers.getSigners();
      const Contract = await ethers.getContractFactory("TsvERC20PartialRefund");
      const contract = await Contract.deploy();
  
      return { contract, owner, otherAccount };
    }
  
    describe("Deployment", function () {
      it("Should deploy and revert on sellBack(1)", async function () {
        const { contract, owner } = await loadFixture(deployOneYearLockFixture)
        await expect(contract.sellBack(1)).to.be.revertedWith(
          "Not enough ether in the contract to sellBack tokens to it"
        )
        // console.log(await contract.provider.getBalance(contract.address))
        expect((await contract.provider.getBalance(contract.address)).toNumber()).to.be.eq(0)
        // console.log(await ethers.provider.getBalance(owner.address))
        tx = await contract.mint({
          value: ethers.utils.parseEther("0.01")
        })
        await tx.wait()
        // console.log(await contract.balanceOf(owner.address))

        tx = await contract.approve(owner.address, 1)
        await tx.wait()
        await expect(contract.sellBack(1)).not.to.be.reverted
      });
    });
  });
  