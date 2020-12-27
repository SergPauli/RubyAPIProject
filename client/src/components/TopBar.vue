<template>
  <div class="layout-topbar">
    <div class="layout-topbar-logo">
      <img class="logo" src="../assets/images/nav-logo.png" alt="logo" />
    </div>
    <a class="layout-menu-button" href="#">
      <i class="pi pi-bars"></i>
    </a>
    <ul class="layout-topbar-menu">
      <li class="layout-topbar-item">
        <a class="layout-topbar-icon first">
          <i class="topbar-icon pi pi-cog"></i>
        </a>
        <ul class="fadeInDown" style="display: none">
          <li>
            <a href="#" class="layout-topbar-icon"
              ><i class="topbar-icon pi pi-bookmark"></i
            ></a>
            <div class="layout-quickmenu-tooltip">
              <div class="layout-quickmenu-tooltip-arrow"></div>
              <div class="layout-quickmenu-tooltip-text">Bookmarks</div>
            </div>
          </li>
          <li>
            <a href="#" class="layout-topbar-icon"
              ><i class="topbar-icon pi pi-chart-bar"></i
            ></a>
            <div class="layout-quickmenu-tooltip">
              <div class="layout-quickmenu-tooltip-arrow"></div>
              <div class="layout-quickmenu-tooltip-text">Statistics</div>
            </div>
          </li>
          <li>
            <a href="#" class="layout-topbar-icon"
              ><i class="topbar-icon pi pi-sign-out"></i
            ></a>
            <div class="layout-quickmenu-tooltip">
              <div class="layout-quickmenu-tooltip-arrow"></div>
              <div class="layout-quickmenu-tooltip-text">Sign Out</div>
            </div>
          </li>
        </ul>
      </li>
      <li class="layout-topbar-item">
        <a class="layout-topbar-icon first"
          ><i class="topbar-icon pi pi-calendar"></i
        ></a>
        <ul class="fadeInDown" style="display: none">
          <li><a href="#" class="layout-topbar-text"> SUN </a></li>
          <li><a href="#" class="layout-topbar-text"> MON </a></li>
          <li><a href="#" class="layout-topbar-text"> TUE </a></li>
        </ul>
      </li>
      <li class="topbar-search layout-topbar-item">
        <a href="#" class="layout-topbar-icon first"
          ><i class="topbar-icon pi pi-search"></i></a
        ><input type="text" placeholder="Type to search..." />
      </li>
      <li class="user-profile">
        <a href="#"
          ><div class="user-profile-info profile-link">
            <span class="user-profile-name">Serge Pauli</span
            ><span class="user-profile-role">Admin</span>
          </div>
          <img
            class="logo"
            src="../assets/images/avatars/admin-ava.jpg"
            alt="admin-ava"
        /></a>
        <ul class="fadeInDown" style="display: none">
          <li class="profile-detail">
            <div class="user-profile-info">
              <img
                class="logo"
                src="../assets/images/avatars/admin-ava.jpg"
                alt="admin-ava"
              />
              <div class="profile-info">
                <span class="user-profile-name">Ava Gregoraci</span
                ><span class="user-profile-role">Design Ops</span>
              </div>
              <a href="#" class="profile-detail-icon"
                ><i class="pi pi-sign-out"></i
              ></a>
            </div>
          </li>
          <li>
            <a href="#"
              ><i class="pi pi-user"></i>
              <div class="menu-text">
                <span class="menu-title">Profile</span
                ><span class="menu-subtitle">Edit your profile</span>
              </div>
              <i class="right-icon pi pi-angle-right"></i
            ></a>
          </li>
          <li>
            <a href="#"
              ><i class="pi pi-cog"></i>
              <div class="menu-text">
                <span class="menu-title">Settings</span
                ><span class="menu-subtitle">Dashboard Settings</span>
              </div>
              <i class="right-icon pi pi-angle-right"></i
            ></a>
          </li>
          <li>
            <a href="#"
              ><i class="pi pi-inbox"></i>
              <div class="menu-text">
                <span class="menu-title">Messages</span
                ><span class="menu-subtitle"
                  >You have a
                  <div class="blue">3 new</div>
                  messages</span
                >
              </div>
              <i class="right-icon pi pi-angle-right"></i
            ></a>
          </li>
          <li>
            <a href="#"
              ><i class="pi pi-globe"></i>
              <div class="menu-text">
                <span class="menu-title">Notification</span
                ><span class="menu-subtitle">No new notification</span>
              </div>
              <i class="right-icon pi pi-angle-right"></i
            ></a>
          </li>
        </ul>
      </li>
    </ul>
  </div>
</template>
<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({
  props: {
    msg: String
  }
})
export default class TopBar extends Vue {
  msg!: string;
}
</script>
