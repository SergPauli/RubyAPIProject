<template>
  <component :is="layout">
    <router-view />
  </component>
</template>
<script lang="ts">
import LoginLayout from "./layouts/LoginLayout.vue";
import MainLayout from "./layouts/MainLayout.vue";
import { defineComponent } from "vue";
export default defineComponent({
  computed: {
    layout(): string {
      return (this.$route.meta.layout || "main") + "-layout";
    }
  },
  components: {
    LoginLayout,
    MainLayout
  }
});
</script>
