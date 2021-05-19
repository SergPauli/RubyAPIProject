<template>
  <div class="home">
    <h1>This Home page</h1>
    
  </div>
</template>

<script>


export default {  
  created() {
    this.$store.dispatch("setActionBarButtons", [])
  }
}
</script>
