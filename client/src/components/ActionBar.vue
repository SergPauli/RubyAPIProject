<template>
  <div class="layout-actionbar" >
    <Breadcrumb class="layout-breadcrumb" :home="home" :model="items" />
    <div class="layout-actions" :key="componentKey">
      <ButtonsBar />      
    </div>
  </div>
</template>

<script>
import ButtonsBar from './ButtonsBar.vue';
export default {
  components: { ButtonsBar },
  mame: "ActionBar",
  data() {
    return {
      componentKey: 0,
    };
  },
  mounted() {
    this.$store.subscribe((mutation, state) => {      
      switch (mutation.type) {
        case "disableBtAction":
          // Update your component with new state data          
          this.forceRerender()
          break;
        case "setButtons":
          // Update your component with new state data          
          this.forceRerender();
        break;  
      }
    });
  },
  computed: {
    buttons() {
      return this.$store.state.buttons;
    },
    getId() {
      return  this.componentKey+"ASS"
    },
    items() {
      const tmp = [];
      if (this.$route.matched) {
        const last = this.$route.matched.slice(-1)[0];
        this.$route.matched.forEach((link) => {
          if (last && link.name != "Home" && link != last)
            tmp.push(Object.assign({ to: link.path }, { label: link.name }));
        });
        if (last && last.name != "Home")
          tmp.push(Object.assign({ label: last.name }, { disabled: true }));
      }
      return tmp;
    },
    home() {
      let home = { label: "Home", disabled: true };
      if (this.$route.matched) {
        const last = this.$route.matched.slice(-1)[0];
        if (last && last.name != "Home") home = { label: "Home", to: "/" };
      }
      return home;
    }    
  },
  methods: {    
    forceRerender() {      
      this.componentKey += 1;
    },
  }
};
</script>

<style>
.layout-actionbar .layout-actions ul > li > button.p-button-success:hover {
  color: rgb(255, 255, 255);
  background: rgb(104, 159, 56);
  border: 1px solid rgb(104, 159, 56); 
 }

.layout-actionbar .layout-actions ul > li > button.p-button-success {  
  color: rgb(104, 159, 56);
}

.layout-actionbar .layout-actions ul > li > button.p-button-help {
  color: rgb(156, 39, 176);  
}
.layout-actionbar .layout-actions ul > li > button.p-button-help:hover {
  background: rgb(140, 35, 158);
  color: rgb(255, 255, 255);
  border-color: rgb(140, 35, 158);
}
.layout-actionbar .layout-actions ul > li > button.p-button-danger {
  color: rgb(211, 47, 47);  
}
.layout-actionbar .layout-actions ul > li > button.p-button-danger:hover {
  background: rgb(170, 36, 36);
  color: rgb(255, 255, 255);
  border-color: rgb(170, 36, 36);
}

.layout-actionbar .layout-actions ul > li > button.p-disabled {
  color: rgb(255, 255, 255) !important;  
}

.layout-actionbar .layout-actions ul > li > button.p-disabled:hover {
  color: rgb(255, 255, 255) !important;  
  background:  rgb(207, 216, 220) !important;
  border-color: rgb(255, 255, 255) !important; 
}
</style>
