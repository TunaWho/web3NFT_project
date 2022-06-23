<template>
  <div class="me">
    <div id="info">
      <div class="type">
        <p class="description border-y-0 border-inherit">
          Hi! I'm Homelander, And I can do whatever the fuck I want.
        </p>
        <p class="description border-y-0 border-inherit">
          Ahh, I'm just joking, but it's so cool. Yeah ^^
        </p>
        <p class="description border-y-0 border-inherit">
          So then, My name is Vincent Hai Nguyen. I live in Da Nang, Vietnam, I
          like anime, and my job is as a web developer.
        </p>
        <p class="description border-y-0 border-inherit">
          I have a dream, and my dream is huge
        </p>
        <p class="description border-y-0 border-inherit">
          I wish I could earn one billion dollars every month. Yeah, I know it
          is a big dream :))
        </p>
      </div>
    </div>
  </div>
</template>
<script setup>
import { onMounted, computed } from 'vue';
import { useStore } from 'vuex';
import Web3 from 'web3';
import { METAMASK } from '@/utils/constants';
import eventBus from '@/events';
import spriteToken from '@/domain/sprite/token';
import { getAccountData } from '@/utils/spriteToken';

const store = useStore();

const web3 = computed(() => {
  return store.state.web3;
});

onMounted(async () => {
  try {
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

      const accountData = await getAccountData(
        web3.value.instance,
        spriteToken[0]
      );

      if (accountData) {
        store.dispatch('account/updateAccountData', accountData);
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
