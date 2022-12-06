import { ethers } from "hardhat";

async function main() {
   const SuperMarioWorld = await ethers.getContractFactory("SuperMarioWorldOZ")
   const superMarioWorld = SuperMarioWorld.deploy("Super Mario World OZ","SPRMO")
   await (await superMarioWorld).deployed()
   console.log("contract was deployed  to ", (await superMarioWorld).address)
    await (await superMarioWorld).mint("https://ipfs.io/ipfs/QmeX9DWdk4nt46CHR5AsezRywjg6AX8km8aic5aqNikA5e")
    await (await superMarioWorld).mint("https://ipfs.io/ipfs/QmeX9DWdk4nt46CHR5AsezRywjg6AX8km8aic5aqNikA5e")
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
