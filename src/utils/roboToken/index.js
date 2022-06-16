/* eslint-disable no-use-before-define, no-console */
import { METAMASK } from '../constants';

/**
 * It gets the balance of a token for a given address
 * @param web3 - the web3 instance
 * @param token
 * @param [accountAddresses] - An array of addresses to get the balance of. If this is empty, it will
 * get the balance of the first address in the web3.eth.accounts array.
 */
export const getAccountData = async (web3, token, accountAddresses = []) => {
  try {
    let accounts = [];

    if (accountAddresses.length > 0) {
      accounts = accountAddresses;
    } else if (sessionStorage.getItem('provider') === METAMASK) {
      accounts = await getAccountForMetaMask();
    } else {
      accounts = await web3.eth.getAccounts();
    }

    let address = accounts[0];

    address = web3.utils.toChecksumAddress(address);
    const contract = new web3.eth.Contract(token.abi, token.contractAddress);

    let balance = await contract.methods
      .balanceOf(address)
      .call({ from: address });

    balance = web3.utils.toBN(balance).toString();

    const symbol = await contract.methods.symbol().call();

    return {
      address,
      balance,
      symbol,
    };
  } catch (e) {
    console.error(e);
    return null;
  }
};

/**
 * It returns an array of accounts from MetaMask.
 * @returns An array of accounts.
 */
export const getAccountForMetaMask = async () => {
  if (!window.ethereum) return {};

  let accounts = [];
  await window.ethereum
    .request({
      method: 'eth_requestAccounts',
    })
    .then(async (acts) => {
      accounts = acts;
    })
    .catch((error) => {
      if (error.code === 4001) {
        console.log('Permissions needed to continue.');
      } else {
        console.log(error);
      }
      accounts = [];
    });

  return accounts;
};
