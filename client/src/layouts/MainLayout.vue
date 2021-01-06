<template>
  <div :class="containerClass">
    <div class="layout-content-wrapper">
      <TopBar
        @topbar-item-click="onTopbarItemClick"
        @menubutton-click="onMenuButtonClick"
        @topbar-menubutton-click="onTopbarMenuButtonClick"
        :topbarMenuActive="topbarMenuActive"
        :horizontal="'horizontal' === layoutMode"
        :activeTopbarItem="activeTopbarItem"
        :user="user"
      />
      <div class="layout-menu-container">
        <div class="overlay-menu-button">
          <div class="overlay-menu-button-bars">
            <span></span><span></span><span></span>
          </div>
          <div class="overlay-menu-button-times"><span></span><span></span></div>
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
    <Toast />  
  </div>
</template>
<script>
import TopBar from "@/components/TopBar.vue"
import EventBus from "@/EventBus"
import { useToast } from "primevue/usetoast"
export default {
  setup() {
    const toast = useToast()    
  },  
  mounted() {
    //console.log("store",this.$store)
     if (this.message.detail) {
        this.showMessage(this.message)        
      }
  },
  data() {
    return {
      layoutMode: "overlay",
      wrapperMode: 1,
      overlayMenuActive: !1,
      mobileMenuActive: !1,
      topbarMenuActive: !1,
      activeTopbarItem: null,
      menuActive: !1,
      isLoggedIn: this.$store.getters.isLoggedIn,
      message: this.$store.getters.message,
      user: this.$store.getters.user
    }
  },
  watch: {
    $route() {
      (this.menuActive = !1), this.$toast.removeAllGroups()
    },    
    message(){
      console.log(this.$store.getters.message)
      //this.showMessage(this.message)
    }
  },
  methods: {
    showMessage(message) {
      this.$toast.add({
        severity: message.severity,
        summary: message.summary,
        detail: message.detail,
        life: 3000
      });
      this.$store.dispatch("clear")
    },
    onDocumentClick: function () {
      this.topbarItemClick ||
        ((this.activeTopbarItem = null), (this.topbarMenuActive = !1)),
        this.menuClick ||
          (this.isHorizontal() &&
            ((this.menuActive = !1), EventBus.emit("reset-active-index")),
          this.hideOverlayMenu()),
        (this.topbarItemClick = !1),
        (this.menuClick = !1)
    },
    onProfileClick: function (e) {
      (this.profileExpanded = !this.profileExpanded),
        this.isHorizontal() && EventBus.emit("reset-active-index"),
        e.preventDefault()
    },
    onMenuClick: function () {
      this.menuClick = !0
    },
    onMenuItemClick: function (e) {
      e.item.items ||
        (EventBus.emit("reset-active-index"),
        this.hideOverlayMenu(),
        this.isHorizontal() && (this.menuActive = !1))
    },
    onRootMenuItemClick: function () {
      this.menuActive = !this.menuActive;
    },
    onMenuButtonClick: function (e) { 
      (this.menuClick = !0),
      (this.topbarMenuActive = !1),
        this.isDesktop()
          ? "overlay" === this.layoutMode &&
            (this.overlayMenuActive = !this.overlayMenuActive)
          : (this.mobileMenuActive = !this.mobileMenuActive)         
        e.preventDefault()
         
    },
    onTopbarMenuButtonClick: function (e) {
      (this.topbarItemClick = !0),
        (this.topbarMenuActive = !this.topbarMenuActive),
        this.hideOverlayMenu(),
        e.preventDefault()
    },
    onTopbarItemClick: function (e) {
      (this.topbarItemClick = !0),
        this.activeTopbarItem === e.item
          ? (this.activeTopbarItem = null)
          : (this.activeTopbarItem = e.item),
        e.originalEvent.preventDefault()
    },
    hideOverlayMenu: function () {
      (this.overlayMenuActive = !1), (this.mobileMenuActive = !1)
    },
    isDesktop: function () {
      return window.innerWidth > 1024
    },
    isHorizontal: function () {
      return "horizontal" === this.layoutMode;
    },
    onLayoutModeChange: function (e) {
      (this.layoutMode = e),
        (this.staticMenuDesktopInactive = !1),
        (this.overlayMenuActive = !1)
    },
    onWrapperModeChange: function (e) {
      this.wrapperMode = e
    },
    onThemeChange: function (e) {
      this.$emit("theme-change", e)
    },
    onLayoutChange: function (e) {
      this.$emit("layout-change", e)
    },
  },
  computed: {
    containerClass() {
      return [
        "layout-wrapper",
        {
          "layout-menu-overlay": "overlay" === this.layoutMode,
          "layout-menu-overlay-active": this.overlayMenuActive,
          "layout-mobile-active": this.mobileMenuActive,
          "layout-menu-horizontal": "horizontal" === this.layoutMode,
          "p-input-filled": true,
          "p-ripple-disabled": !1 === this.$primevue.ripple,
        },
        {
          "layout-fullwidth": this.wrapperMode,
        },
      ]
    },
  },
  components: { TopBar },
}
</script>
