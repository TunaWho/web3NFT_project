<template>
  <div class="web3-content">
    <div id="mint">
      <div>
        <h1 id="title">Sprites</h1>
        <p id="description">
          It's 2078. Can the Sprites NFT save humans from destructive rampant
          NFT speculation? Mint Sprites to find out.
        </p>
        <div v-if="store.state.isLogin">
          <div id="chosen-amounts">
            <button id="decrement" @click="handleDecrement">-</button>
            <input
              class="text-gray-800 text-sm"
              :value="mintAmount"
              type="number"
              readonly
            />
            <button id="increment" @click="handleIncrement">+</button>
          </div>
          <loading-button
            id="minting"
            :disabled="onLoading"
            :is-loading="onLoading"
            @click="mintNFT"
          >
            Mint
          </loading-button>
        </div>
        <p v-else id="get-connect">Connect to mint NFT</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useStore } from 'vuex';
import Web3 from 'web3';
import spriteToken from '@/domain/sprite/token';
import { getAccountData, canMint } from '@/utils/spriteToken';
import eventBus from '@/events';
import { METAMASK, MINT_FEE } from '@/utils/constants';
import LoadingButton from '../buttons/LoadingButton.vue';

const store = useStore();
const mintAmount = ref(1);
const checkStatusInterval = ref(null);
const onLoading = ref(false);

const web3 = computed(() => {
  return store.state.web3;
});

const account = computed(() => {
  return store.state.account;
});

const mintAmountBN = computed(() => {
  return web3.value.instance.utils.toBN(mintAmount.value);
});

const totalMintFee = computed(() => {
  return web3.value.instance.utils.toWei(
    (MINT_FEE * mintAmount.value).toString()
  );
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
  onLoading.value = false;

  eventBus.$emit('toastify', {
    title: 'Minted NFT!',
    type: 'success',
    content: 'Your NFT fund has been minted',
  });
}

function incompleteTransaction() {
  onLoading.value = false;

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
  const { abi, contractAddress } = spriteToken[0];
  const spritePoolContract = new web3.value.instance.eth.Contract(
    abi,
    contractAddress
  );

  canMint(web3.value.instance, account.value.address).then((result) => {
    onLoading.value = true;

    if (result) {
      spritePoolContract.methods
        .mint(mintAmountBN.value)
        .send({ from: account.value.address, value: totalMintFee.value })
        .on('transactionHash', (transactionHash) => {
          sessionStorage.setItem('transactionHash', transactionHash);
          checkTransactionStatus(transactionHash, 10);
        })
        .on('error', () => {
          incompleteTransaction();
        });
    } else {
      onLoading.value = false;

      eventBus.$emit('toastify', {
        title: 'Error',
        type: 'error',
        content: 'you have reached the limit minting NFT!',
      });
    }
  });
}

function handleChainChanged() {
  window.location.reload();
}

function handleDisconnected() {
  store.dispatch('onLogout');
}

onMounted(async () => {
  try {
    await eventBus.$emit('toastify', {
      title: 'Connect Failed',
      type: 'error',
      content: 'Please check the network!',
    });
    setTimeout(() => {
      console.log('Please');
    }, 0);
    await eventBus.$emit('toastify', {
      title: 'Connect Failed',
      type: 'success',
      content: 'Please check the network!',
    });
    console.log('ok3');
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

      // Subscribe to chainId change
      web3.value.instance.currentProvider.on('chainChanged', (chainId) => {
        handleChainChanged(chainId);
      });

      // Subscribe to session disconnection
      web3.value.instance.currentProvider.on('disconnect', () => {
        handleDisconnected();
      });

      const accountData = await getAccountData(
        web3.value.instance,
        spriteToken[0]
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
