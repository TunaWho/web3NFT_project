<template>
  <section class="overlay">
    <section class="main">
      <nav-header></nav-header>
      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </section>
    <div class="background-effect"></div>
    <toast-notify></toast-notify>
  </section>
</template>

<script setup>
import NavHeader from '@/components/NavBar.vue';
import ToastNotify from '@/components/ToastNotify.vue';
</script>

<style lang="scss" src="@/assets/scss/common.scss"></style>
