const hre = require('hardhat');
const { ethers, upgrades } = require('hardhat');
const { promisify } = require('util');

const sleep = promisify(setTimeout);
const args = [
  200,
  5,
  '.json',
  'SpritesV1',
  'TSP',
  process.env.VUE_APP_ADMIN_ADDRESS,
];

async function deployAndVerify(contractName, constructorArguments = []) {
  const factory = await ethers.getContractFactory(contractName);
  console.log('Deploying', contractName, '...');

  const contract = await upgrades.deployProxy(
    factory,
    ...constructorArguments,
    {
      initializer: 'initialize',
    }
  );

  await contract.deployed();
  console.log(contractName, ' deployed to:', contract.address);
  const impAdress = await upgrades.erc1967.getImplementationAddress(
    contract.address
  );

  if (hre.network.name !== 'hardhat') {
    const { sourceName } = await hre.artifacts.readArtifact(contractName);
    const maxErrors = 5;
    const errors = [];

    /* eslint-disable no-await-in-loop */
    while (errors.length < maxErrors) {
      try {
        await hre.run('verify:verify', {
          address: impAdress,
          constructorArguments,
          contract: `${sourceName}:${contractName}`,
        });
        break;
      } catch (e) {
        if (e.message.includes('Contract source code already verified')) {
          break;
        } else {
          errors.push(e);
        }
      }
      console.log('contract not yet deployed. waiting...');
      await sleep(8000);
    }
    /* eslint-enable no-await-in-loop */

    if (errors.length === maxErrors) {
      throw errors[maxErrors - 1];
    }
  }

  return contract.address;
}

async function main() {
  await deployAndVerify('Sprites', args);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
