<template>
  <body class="login-body">
    <div class="mobile-banner">
      <img src="../assets/images/logo.png" alt="prestige-layout" />
    </div>
    <div class="login-panel">
      <div class="logo">
        <img
          src="../assets/images/logo.png"
          alt="prestige-layout"
          height="80"
        />
      </div>
    </div>
    <router-view />
  </body>
</template>
<script>
import { Vue } from "vue-class-component";
export default class LoginLayout extends Vue {}
</script>
