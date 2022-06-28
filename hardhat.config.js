/* eslint-disable */
require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-etherscan');
require('@nomiclabs/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');
require('hardhat-abi-exporter');

const dotenv = require('dotenv');

dotenv.config();

const settings = {
  optimizer: {
    enabled: true,
    runs: 200,
  },
};


/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      { version: '0.8.2', settings },
      { version: '0.8.4', settings }
    ],
    defaultNetwork: 'hardhat',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    rinkeby: {
      url: process.env.VUE_APP_RINKEBY_RPC_URL,
      accounts: [process.env.VUE_APP_PRIVATE_KEY]
    }
  },
  abiExporter: {
    path: './data/abi',
    clear: false,
    flat: true
  },
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts'
  },
  mocha: {
    timeout: 20000
  },
  etherscan: {
    apiKey: process.env.VUE_APP_ETHERSCAN_KEY
  },
};
