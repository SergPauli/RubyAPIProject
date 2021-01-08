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
    <ToastSpot />    
  </body>
</template>
<script>
import { defineComponent } from "vue"
import ToastSpot from "@/components/ToastSpot.vue"
export default defineComponent({   
  
  components: {   
    ToastSpot
  }
})
</script>
