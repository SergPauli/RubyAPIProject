import { createStore } from "vuex"
import authService from "@/service/authService"
const savedUser  = localStorage.getItem("user") || "{}"
const bArray: boolean[] = []
interface ButtonActonBar {
  title?: string
  icon?: string  
  disabled?: boolean
  code?: number
  key?:string
}
const itemKey = ()=>{      
      let id = "";
      const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      for (let i = 0; i < 2; i++) {
        id += chars.charAt(Math.floor(Math.random() * chars.length));
      }
      return id;
    } 
const btArray: ButtonActonBar[] = []
export default createStore({
  state: {
    message: {},
    status: "",
    session: {
      token: localStorage.getItem("token") || "",
      user: savedUser === "{}" ? {} : JSON.parse(savedUser),
    },
    buttons: btArray,
    btCode: 0,    
    personDialog: {visible: false,  person: {contacts:[]}, submitted: false}    
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
    setButtons(state, buttons: ButtonActonBar[]) {
      buttons.forEach((bt) => (bt.key = itemKey()))
      state.buttons = buttons
    },
    setBtAction(state, code) {
      state.btCode = code
    },
    disableBtAction(state, data) {
      const button = state.buttons.find((bt) => bt.code == data.code)
      if (button) {        
        button.disabled = data.disabled
        button.key = itemKey()        
      }
    },
    setPersonDialog(state, data) {
      state.personDialog=data
    },
    message(state, message) {
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
      return new authService(data.router).login(data).then((response) => commit("login", response))
      //.catch((error)=>commit("error", error.message))
    },
    logout({ commit }, data) {
      commit("loading")
      return new authService(data.router)
        .logout()
        .then((response) => commit("logout", response))
        .catch((error) => commit("message", { severity: "error", summary: "Error", detail: error.message }))
    },
    error401({ commit }, data) {
      commit("logout", data)
      //commit("message", { message: { severity: "error", summary: "Access denied", detail: "Unauthorized" } })
    },
    putMessage({ commit }, message) {
      commit("message", message)
    },
    clear({ commit }) {
      commit("clear")
    },
    setActionBarButtons({ commit }, buttons: ButtonActonBar[]) {
      commit("setButtons", buttons)
    },
    clickActionBarButton({ commit }, code) {
      commit("setBtAction", code)
    },
    disableBtAction({ commit }, data) {
      commit("disableBtAction", data)
    },
    setPersonDialogData({commit}, data) {
      commit("setPersonDialog", data)
    }
  },
  getters: {
    isLoggedIn: (state) => state.session.token != "",
    authStatus: (state) => state.status,
    token: (state) => state.session.token,
    user: (state) => state.session.user,
    message: (state) => state.message,
    status: (state) => state.status,
    btCode: (state) => state.btCode,
    buttons: (state) => state.buttons,
  },
  modules: {},
})
