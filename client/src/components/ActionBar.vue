<template>
  <div class="layout-actionbar">
    <Breadcrumb class="layout-breadcrumb" :home="home" :model="items" />
    <div class="layout-actions">
      <ul>
        <li>
          <button>
            <i class="pi pi-inbox icon"></i>
          </button>
        </li>
        <li>
          <button>
            <i class="pi pi-file-o icon"></i>
          </button>
        </li>
        <li>
          <button>
            <i class="pi pi-info-circle icon"></i>
          </button>
        </li>
        <li>
          <button>
            <i class="pi pi-user icon"></i>
          </button>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  mame: "ActionBar",  
  computed: {
    items() {
      const tmp = [];
      if (this.$route.matched) {        
        const last = this.$route.matched.slice(-1)[0]
        this.$route.matched.forEach((link) => {                   
          if (link.name!="Home" && link!=last) tmp.push(Object.assign({ to: link.path }, {label: link.name}))          
        })
        if (last.name!="Home") tmp.push(Object.assign({label: last.name}, {disabled: true}))
      }          
      return tmp
    },
    home() { 
      let home = { label: "Home",  disabled: true }
      if (this.$route.matched) {        
        const last = this.$route.matched.slice(-1)[0]        
        if (last.name!="Home")  home = {label: "Home", to: "/" }
      }          
      return home
    }
  },  
}
</script>

<style></style>
