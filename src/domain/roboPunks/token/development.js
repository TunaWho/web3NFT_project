import roboPunk from '../abis/development/roboPunk';

const host = 'https://rinkeby.etherscan.io/address';

export default [
  {
    title: 'Robot Punks NFT',
    contractAddress: '0x10A40bf69890c144c29911be17D5a14d7362EEAb',
    minApr: 175,
    abi: roboPunk.abi,
    url: `${host}/0x10A40bf69890c144c29911be17D5a14d7362EEAb`,
  },
];
