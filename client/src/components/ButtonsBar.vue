<template>
  <ul>    
      <li v-for="button of model" :key="button.key">
        <button  v-if="button.disabled"          
          :class="button.class + ' p-disabled'"
           :disabled="'disabled'" >
          <i :class="button.icon + ' icon'"></i>
        </button>
        <button  v-else  @click="setActionCode(button.code)"        
          :class="button.class" >
          <i :class="button.icon + ' icon'"></i>
        </button>
      </li>    
  </ul>
</template>
<script>

export default {  
  data() {
        return {
            model: this.$store.state.buttons
        }
    },
    methods: {
        setActionCode(code){            
            this.$store.dispatch("clickActionBarButton", code);      
        }
    }
};
</script>
