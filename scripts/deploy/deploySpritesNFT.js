const hre = require('hardhat');

async function main() {
  const SpritesNFT = await hre.ethers.getContractFactory('SpritesNFT');
  const spritesNFT = await SpritesNFT.deploy('SpritesAnger', 'SPA');

  await spritesNFT.deployed();

  console.log('spritesNFT deployed to:', spritesNFT.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
