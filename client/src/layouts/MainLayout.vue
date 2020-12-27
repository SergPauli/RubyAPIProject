<template>
  <div class="layout-wrapper layout-menu-overlay layout-fullwidth">
    <div class="layout-content-wrapper">
      <TopBar />
      <div class="layout-menu-container">
        <div class="overlay-menu-button">
          <div class="overlay-menu-button-bars">
            <span></span><span></span><span></span>
          </div>
          <div class="overlay-menu-button-times">
            <span></span><span></span>
          </div>
        </div>
        <div class="layout-menu-wrapper fadeInDown">
          <ul role="menu" class="layout-menu clearfix">
            <li role="none">
              <a class="p-ripple" role="menuitem">
                <i class="layout-menuitem-icon pi pi-fw pi-shopping-cart"></i>
                <span class="layout-menuitem-text">Buy Now</span
                ><span class="p-ink"></span
              ></a>
            </li>
          </ul>
        </div>
      </div>
      <div class="layout-actionbar">
        <div class="layout-breadcrumb">Home</div>
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
      <div class="layout-content">
        <router-view />
      </div>
    </div>
    <div class="layout-footer"></div>
    <div class="layout-mask"></div>
  </div>
</template>
<script>
import TopBar from "@/components/TopBar.vue";
export default {
  components: { TopBar }
};
</script>
