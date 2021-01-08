<template>
  <Toast /> 
</template>
<script >
import { useToast } from "primevue/usetoast"
import { mapState } from "vuex"
export default  {   
  computed: mapState(['message']),
  mounted() {
    if (this.$store.state.message.detail) this. showMessage(this.$store.state.message)
  },
  created() {
    this.unwatch = this.$store.watch(
      (state, getters) => getters.message,
      (newValue, oldValue) => {
        //console.log(`Updating from ${JSON.stringify(oldValue)} to ${JSON.stringify(newValue)}`) 
        if (newValue.detail && this.$store.state.status==="") this.showMessage(newValue)
      },
    )
  },
  beforeUnmount() {
    this.unwatch();
  },
  watch: {
    $route() {
      this.$toast.removeAllGroups()
    },    
  },
  methods: {
    showMessage(message) {
     //console.log('sm', this.$store.state.status) 
      this.$toast.add({
        severity: message.severity,
        summary: message.summary,
        detail: message.detail,
        life: 3000,
      });
      this.$store.dispatch("clear");
    },
  },
}
</script>
