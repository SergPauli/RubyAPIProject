import { createStore } from "vuex"
import authService from "@/service/authService"
const savedUser  = localStorage.getItem("user") || "{}"
console.log("savedUser:", savedUser)
export default createStore({
  state: {
    message: {},
    status: "",
    session: {
      token: localStorage.getItem("token") || "",
      user: savedUser ? {} : JSON.parse(savedUser),
    },
  },
  mutations: {
    loading(state) {
      state.status = "loading"
    },
    login(state, data) {
      state.session.user = data.data
      state.session.token = data.token
      state.message = { severity: "success", summary: "success", detail: data.message }
      localStorage.setItem("user", JSON.stringify(state.session.user))
      localStorage.setItem("token", state.session.token)
      state.status = "Authorized"
    },
    logout(state, data) {
      state.session.token = ""
      state.status = "Exit"
      state.message = { severity: "success", summary: "success", detail: data.message }
      localStorage.removeItem("token")
    },
    message(state, message) {
      console.log("state.message:", message)
      state.message = message
    },
    clear(state) {
      state.status = ""
      state.message = {}
    },
  },
  actions: {
    login({ commit }, data) {
      commit("loading")
      return new authService().login(data).then((response) => commit("login", response))
      //.catch((error)=>commit("error", error.message))
    },
    logout({ commit }, data) {
      commit("loading")
      return new authService()
        .logout()
        .then((response) => commit("logout", response))
        .catch((error) => commit("message", { severity: "error", summary: "Error", detail: error.message }))
    },
    error401({ commit }) {
      commit("logout")
      commit("message", { message: { severity: "error", summary: "Access denied", detail: "Unauthorized" } })
    },
    putMessage({ commit }, message) {
      commit("message", message)
    },
    clear({ commit }) {
      commit("clear")
    },
  },
  getters: {
    isLoggedIn: (state) => !!state.session.token,
    authStatus: (state) => state.status,
    token: (state) => state.session.token,
    user: (state) => state.session.user,
    message: (state) => state.message,
  },
  modules: {},
})
