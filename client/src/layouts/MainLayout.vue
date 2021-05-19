<template>
  <div :class="containerClass">
    <div class="layout-content-wrapper" @click="onDocumentClick">
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
        <div class="overlay-menu-button" @click="onMenuButtonClick">
          <div class="overlay-menu-button-bars">
            <span></span><span></span><span></span>
          </div>
          <div class="overlay-menu-button-times"><span></span><span></span></div>
        </div>
        <MainMenu />
      </div>
      <ActionBar />
      <div id='contentDiv' class="layout-content" :style="{padding: '0'}">
        <router-view />        
      </div>
      <ToastSpot /> 
    </div>
    <div v-if="isFooter" class="layout-footer"></div>
    <div class="layout-mask"></div>      
  </div>
</template>
<script>
import TopBar from "@/components/TopBar.vue"
import ActionBar from "@/components/ActionBar.vue"
import ToastSpot from "@/components/ToastSpot.vue"
import EventBus from "@/EventBus"
import MainMenu from '../components/MainMenu.vue'
export default { 
  data() {
    return {
      isFooter: false,
      layoutMode: "overlay",
      wrapperMode: 1,
      overlayMenuActive: !1,
      mobileMenuActive: !1,
      topbarMenuActive: !1,
      activeTopbarItem: null,
      menuActive: !1,
      isLoggedIn: this.$store.getters.isLoggedIn,      
      user: this.$store.getters.user
    }
  },  
  watch: {
    $route() {
      (this.menuActive = !1)
    },
  },    
  methods: {    
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
  components: { TopBar, ToastSpot, ActionBar, MainMenu },
}
</script>
