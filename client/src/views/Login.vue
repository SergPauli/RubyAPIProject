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
        <button class="p-button p-component" type="button" @click="loginHandler">
          <span class="p-button-label">Sign In</span>
          <span class="p-ink"></span>
        </button>
      </div>      
    </div>        
  </div>  
</template>
<script>
import { defineComponent } from "vue";
import { useToast } from "primevue/usetoast"
export default defineComponent({
  setup() {
    const toast = useToast();
  },
  data() {
    return {
      username: this.$store.getters.user ? this.$store.getters.user.login : null,
      password: null,
      message: this.$store.getters.message      
    };
  },
  watch: {    
    message(){
      if (this.message) {
        this.$toast.add({ severity: this.message.severity, summary: this.message.summary, detail: this.message.detail });
        this.$store.dispatch("clearMessage")
      }
    }
  },
  methods: {
    loginHandler() {
      if (this.username && this.username.length>2 && this.password && this.password.length>5) {
        const data = {
          login: this.username,
          password: this.password,
        };
        this.$store.dispatch("login", data).then((result) => {
          this.$router.push("/");
        }).catch((error)=>this.message =  {severity:"error", detail: error.message, summary:"Access denied" });
      } else  this.message= {severity:"error", summary: "Error", detail:"login or passord is incorrect"}  
    },
  },
})
</script>
