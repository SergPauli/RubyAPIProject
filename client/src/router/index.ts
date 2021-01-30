import store from "@/store"
import { createRouter, createWebHistory, RouteRecordRaw } from "vue-router"
import Home from "../views/Home.vue"
import Login from "../views/Login.vue"


const routes: Array<RouteRecordRaw> = [
  {
    path: "/",
    name: "Home",
    meta: { layout: "main", requiresAuth: true },
    component: Home,
  },
  {
    path: "/about",
    name: "About",
    meta: { layout: "main", requiresAuth: true },
    component: () => import(/* webpackChunkName: "about" */ "../views/About.vue"),
  },
  {
    path: "/login",
    name: "Login",
    meta: { layout: "login" },
    component: Login,
  },
  {
    path: "/Items/People",
    name: "People",
    meta: { layout: "main", requiresAuth: true },
    component: () => import(/* webpackChunkName: "about" */ "../views/Items/People.vue"),
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})
router.beforeEach((to, from, next) => { 
  //console.log("to",to) 
  //console.log("from", from)
  //console.log("token", store.getters.user)
  if(to.matched.some(record => record.meta.requiresAuth)) {
    if (store.getters.isLoggedIn) {
      next()
      return
    } next("/login")     
  } else if (to.matched.some((record) => record.name === "Login") && store.getters.isLoggedIn) next("/")
    else next() 
})
export default router;
