<template>
  <div>
    <h1>RoboPunks</h1>
    <p>
      It's 2078. Can the RoboPunks NFT save humans from destructive rampant NFT
      speculation? Mint RoboPunks to find out.
    </p>
    <div v-if="store.state.isLogin">
      <div>
        <button @click="handleDecrement">-</button>
        <input :value="mintAmount" type="number" />
        <button @click="handleIncrement">+</button>
      </div>
      <button @click="mintNFT">Mint now</button>
    </div>
    <p v-else>Connect to mint NFT</p>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useStore } from 'vuex';
import Web3 from 'web3';
import roboToken from '@/domain/roboPunks/token';
import { getAccountData } from '@/utils/roboToken';
import eventBus from '@/events';
import { METAMASK } from '@/utils/constants';

const store = useStore();
const mintAmount = ref(1);
const checkStatusInterval = ref(null);

const web3 = computed(() => {
  return store.state.web3;
});

const account = computed(() => {
  return store.state.account;
});

function handleDecrement() {
  if (mintAmount.value <= 1) return;

  mintAmount.value -= 1;
}

function handleIncrement() {
  if (mintAmount.value >= 3) return;

  mintAmount.value += 1;
}

function completeTransaction() {
  eventBus.$emit('toastify', {
    title: 'Minted NFT!',
    type: 'success',
    content: 'Your NFT fund has been minted',
  });
}

function incompleteTransaction() {
  eventBus.$emit('toastify', {
    title: 'Error',
    type: 'error',
    content:
      'Please try again. Confirm the transaction and make sure you are paying enough gas!',
  });
}

function checkTransactionStatus(transactionHash, seconds) {
  checkStatusInterval.value = setInterval(() => {
    web3.value.instance.eth
      .getTransactionReceipt(transactionHash)
      .then((result) => {
        if (result) {
          if (result.status) {
            clearInterval(checkStatusInterval.value);
            completeTransaction();
          }
        }
      });
  }, seconds * 1000);
}

function mintNFT() {
  const { abi, contractAddress } = roboToken[0];
  const roboPoolContract = new this.web3.instance.eth.Contract(
    abi,
    contractAddress
  );

  roboPoolContract.methods
    .mint(mintAmount.value)
    .send({ from: account.value.address })
    .on('transactionHash', (transactionHash) => {
      sessionStorage.setItem('transactionHash', transactionHash);
      checkTransactionStatus(transactionHash, 10);
    })
    .on('error', () => {
      incompleteTransaction();
    });
}

onMounted(async () => {
  try {
    console.log(store.state.isLogin);
    if (store.state.isLogin) {
      console.log(sessionStorage.getItem('provider'));
      if (sessionStorage.getItem('provider') === METAMASK) {
        if (!window.ethereum) {
          return;
        }
        const instance = new Web3(window.ethereum);
        const chainId = await instance.eth.net.getId();
        store.dispatch('web3/update', {
          instance,
          chainId,
          provider: METAMASK,
        });
      }

      // // Subscribe to accounts change
      // web3.value.instance.currentProvider.on('accountsChanged', (accounts) => {
      //   handleAccountChanged(accounts);
      // });

      // // Subscribe to chainId change
      // web3.value.instance.currentProvider.on('chainChanged', (chainId) => {
      //   handleChainChanged(chainId);
      // });

      // // Subscribe to session disconnection
      // web3.value.instance.currentProvider.on('disconnect', () => {
      //   handleDisconnected();
      // });

      const accountData = await getAccountData(
        web3.value.instance,
        roboToken[0]
      );

      if (accountData) {
        store.dispatch('account/updateAccountData', accountData);
        eventBus.$emit('toastify', {
          title: 'Account Connected',
          type: 'success',
          content: 'Your account is connected!',
        });
      } else {
        eventBus.$emit('toastify', {
          title: 'Connect Failed',
          type: 'error',
          content: 'Please check the network!',
        });
      }
    }
  } catch (error) {
    console.log(error);
    throw Error('Pool is not loading, something wrong!');
  }
});
</script>

<style lang="scss" scoped></style>
