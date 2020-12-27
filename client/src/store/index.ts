import { createStore } from "vuex";

export default createStore({
  state: { user: JSON.parse(localStorage.getItem("user") || "{}") },
  mutations: {
    login(state, data) {
      state.user = data;
      localStorage.setItem("user", JSON.stringify(state.user));
    }
  },
  actions: {
    login({ commit }, data) {
      commit("login", data);
    }
  },
  modules: {}
});
