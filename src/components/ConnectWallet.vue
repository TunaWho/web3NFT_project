<template>
  <div class="auth-wallet">
    <button @click="connectWithMetamask">Connect to wallet</button>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useStore } from 'vuex';
import Web3 from 'web3';
import { getAccountData } from '@/utils/roboToken';
import { METAMASK } from '@/utils/constants';
import eventBus from '@/events';
import roboPunksToken from '@/domain/roboPunks/token';

const store = useStore();

const web3 = computed(() => {
  return store.state.web3;
});

async function connectWithMetamask() {
  try {
    if (!window.ethereum) {
      return;
    }

    const instance = new Web3(Web3.givenProvider);
    const chainId = await instance.eth.net.getId();
    sessionStorage.setItem('provider', METAMASK);

    store.dispatch('web3/update', {
      instance,
      chainId,
      provider: METAMASK,
    });

    const accountData = await getAccountData(
      web3.value.instance,
      roboPunksToken[0]
    );

    if (accountData) {
      sessionStorage.setItem('address', accountData.address);
      window.location.reload();
    } else {
      eventBus.$emit('toastify', {
        title: 'Connect Failed',
        type: 'error',
        content: 'Please check the network!',
      });
    }
  } catch (e) {
    console.log(e);
  }
}
</script>

<style lang="scss" scoped></style>
