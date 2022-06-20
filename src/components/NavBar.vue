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
      <div>Me</div>
      <div>Mint</div>
      <div>Description</div>
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
