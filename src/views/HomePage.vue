<template>
  <section class="overlay">
    <section class="main">
      <nav-header></nav-header>
      <mint-token></mint-token>
    </section>
    <div class="background-effect"></div>
    <toast-notify></toast-notify>
  </section>
</template>

<script setup>
import NavHeader from '@/components/NavBar.vue';
import ToastNotify from '@/components/ToastNotify.vue';
import MintToken from '@/components/token/MintToken.vue';
</script>

<style lang="scss" src="@/assets/scss/common.scss"></style>
