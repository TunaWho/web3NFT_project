<template>
  <div class="auth-wallet">
    <button v-if="!store.state.isLogin" @click="connectWithMetamask">
      Connect to wallet
    </button>
    <button
      v-else-if="store.state.isLogin"
      class="wallet-address"
      @click="showLogout = !showLogout"
    >
      {{ displayAddress }}
    </button>
  </div>
  <transition
    enter-active-class="animate__animated animate__fadeInLeft"
    leave-active-class="animate__animated animate__backOutRight"
  >
    <account-wallet v-if="showLogout"></account-wallet>
  </transition>
</template>

<script setup>
import { computed, ref } from 'vue';
import { useStore } from 'vuex';
import Web3 from 'web3';
import { getAccountData } from '@/utils/spriteToken';
import { METAMASK } from '@/utils/constants';
import eventBus from '@/events';
import spriteToken from '@/domain/sprite/token';
import AccountWallet from './AccountWallet.vue';

const showLogout = ref(false);
const store = useStore();

const web3 = computed(() => {
  return store.state.web3;
});

const displayAddress = computed(() => {
  const { address } = store.state.account;
  if (address.length > 10) {
    return `${address.substr(0, 6)}...${address.substr(-4)}`;
  }

  return address;
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
      spriteToken[0]
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

<style lang="scss" scoped>
@import 'https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css';

.wallet-address {
  font-size: 8px !important;
}
</style>
