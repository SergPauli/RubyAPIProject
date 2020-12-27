<template>
  <div class="login-card">
    <div class="top-border"></div>
    <div class="login-content">
      <h1>Login</h1>
      <p>Welcome, please use the form to sign-in.</p>
      <div class="username-container">
        <label>Username</label>
        <div class="login-input">
          <InputText type="text" v-model="username" placeholder="username" />
        </div>
      </div>
      <div class="password-container">
        <label>Password</label>
        <div class="login-input">
          <Password v-model="password" :feedback="false" />
        </div>
      </div>
      <div>
        <button
          class="p-button p-component"
          type="button"
          @click="loginHandler"
        >
          <span class="p-button-label">Sign In</span>
          <span class="p-ink"></span>
        </button>
        <Toast />
      </div>
    </div>
  </div>
</template>
<script>
import { defineComponent } from "vue";
import { useToast } from "primevue/usetoast";
export default defineComponent({
  setup() {
    const toast = useToast();
  },
  data() {
    console.log(this.$store.state);
    return {
      username: this.$store.state.user ? this.$store.state.user.username : null,
      password: null
    };
  },
  methods: {
    showError(detail) {
      this.$toast.add({
        severity: "Error",
        summary: "Error",
        detail: detail,
        life: 3000
      });
    },
    loginHandler() {
      const data = {
        username: this.username,
        password: this.password
      };
      const response = await fetch(url, {method: method, body: body, headers: headers}) //запрос к API
        const data = await response.json() //парсим полученный ответ
        if (!response.ok) { // возникла ошибка, если есть месэдж, выводим его
          this.showError(data.message);
        }
      this.$store.dispatch("login", data);      
      this.$router.push("/");
    }
  }
});
</script>
