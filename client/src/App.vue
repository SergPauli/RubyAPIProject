<template>
  <component :is="layout">
    <router-view /> 
    <Toast />    
  </component>  
</template>
<script lang="ts">
import LoginLayout from "./layouts/LoginLayout.vue"
import MainLayout from "./layouts/MainLayout.vue"
import { defineComponent } from "vue"
export default defineComponent({
  
  computed: {
    layout(): string {
      return (this.$route.meta.layout || "main") + "-layout"
    }
  },
  watch: {

  },
  components: {
    LoginLayout,
    MainLayout
  }
})
</script>
