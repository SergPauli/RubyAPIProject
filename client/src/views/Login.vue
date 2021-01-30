<template>
  <ProgressSpinner v-if="isLoading" style="width:30%;height:30%;margin: auto;"/>
  <div class="login-card" v-else >
    <div class="top-border"></div>    
    <div class="login-content" >
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
import { defineComponent } from "vue"
import { mapState } from "vuex"
export default defineComponent({ 
  name: "LOGIN", 
  data() {
    return {
      username: this.$store.getters.user ? this.$store.getters.user.login : null,
      password: null,
      isLoading: this.$store.status == 'loading'            
    };
  },
  computed: mapState(['status']),  
  methods: {
    loginHandler() {
      if (this.username && this.username.length>2 && this.password && this.password.length>5) {
        const data = {
          login: this.username,
          password: this.password,
        };
        this.$store.dispatch("login", data).then((result) => {
          this.$router.push("/");
        }).catch((error)=>{this.$store.dispatch("putMessage", {severity:"error", detail: error.message, summary:"Access denied" })})
      } else  this.$store.dispatch("putMessage", {severity:"error", summary: "Error", detail:"login or passord is incorrect"})  
    },
  },
})
</script>
