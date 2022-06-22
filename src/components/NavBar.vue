<template>
  <div class="navigation">
    <!-- left side -->
    <div class="social-media">
      <div>
        <a href="https://facebook.com/" active-class="active">
          <img :src="Facebook" class="social-media-icon" />
        </a>
      </div>
      <div>
        <a href="https://twitter.com/" active-class="active">
          <img :src="Twitter" class="social-media-icon" />
        </a>
      </div>
      <div>
        <a href="https://gmail.com/" active-class="active">
          <img :src="Email" class="social-media-icon" />
        </a>
      </div>
    </div>
    <!-- end left side -->

    <!-- right side -->
    <div class="info-links">
      <router-link class="link" to="/me">
        <div>Me</div>
      </router-link>
      <router-link class="link" to="/">
        <div>Mint</div>
      </router-link>
      <router-link class="link" to="javascript:void(0)">
        <div>Contact</div>
      </router-link>
      <connect-wallet></connect-wallet>
    </div>
    <!-- end right side -->
  </div>
</template>

<script setup>
import ConnectWallet from '@/components/wallet/ConnectWallet.vue';
import Facebook from '@/assets/images/social-media-icons/facebook_32x32.png';
import Twitter from '@/assets/images/social-media-icons/twitter_32x32.png';
import Email from '@/assets/images/social-media-icons/email_32x32.png';
</script>
