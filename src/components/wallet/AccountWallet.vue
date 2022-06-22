<template>
  <div id="logout" @click="onLogout">Logout</div>
</template>

<script setup>
import { useStore } from 'vuex';

const store = useStore();

function onLogout() {
  store.dispatch('onLogout');
}
</script>

<style lang="scss" scoped>
#logout {
  position: absolute;
  right: 140px;
  top: 75px;
  padding: 15px;
  font-size: 8px;
  background-color: #0c0c0c;
  border-radius: 5px;
  cursor: pointer;
  font-family: inherit;
  white-space: nowrap;
}
</style>
