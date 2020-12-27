import { createRouter, createWebHistory, RouteRecordRaw } from "vue-router";
import Home from "../views/Home.vue";

const routes: Array<RouteRecordRaw> = [
  {
    path: "/",
    name: "Home",
    meta: { layout: "main" },
    component: Home
  },
  {
    path: "/about",
    name: "About",
    meta: { layout: "main" },
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/About.vue")
  },
  {
    path: "/login",
    name: "Login",
    meta: { layout: "login" },
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/Login.vue")
  }
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
});

export default router;
