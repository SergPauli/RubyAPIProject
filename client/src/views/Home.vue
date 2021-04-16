<template>
  <div class="home">
    <h1>This Home page</h1>
    <InputText type="text"  v-tooltip.right="'Enter your username'" />
  </div>
</template>

<script>


export default {  
  created() {
    this.$store.dispatch("setActionBarButtons", [])
  }
}
</script>
