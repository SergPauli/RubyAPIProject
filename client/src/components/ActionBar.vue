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
  data() {
    return {
      home: { icon: "pi pi-home", to: "/" },
    };
  },
  computed: {
    items() {
      const tmp = [];
      if (this.$route.matched) {
        this.$route.matched.forEach((link) => {
          //console.log(JSON.stringify(link));
          if (link.name!="Home") tmp.push(Object.assign({ to: link.path }, {label: link.name}));
        });
      }
      return tmp;
    },
  },
  //   methods: {
  //     home() {
  //       this.$router.push({
  //         path: "/",
  //       });
  //     },
  //   },
};
</script>

<style></style>
