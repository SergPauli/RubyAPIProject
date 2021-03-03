<template>
  <div class="home">
    <h1>This Home page</h1>
    <InputText type="text"  v-tooltip.right="'Enter your username'" />
  </div>
</template>

<script lang="ts">
import { Vue } from "vue-class-component";

export default class Home extends Vue {  
}
</script>
