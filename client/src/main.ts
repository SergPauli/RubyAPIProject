import { createApp } from "vue"
import App from "./App.vue"
import router from "./router"
import PrimeVue from "primevue/config"
import InputText from "primevue/inputtext"
import Password from "primevue/password"
import ToastService from "primevue/toastservice"
import Toast from "primevue/toast"
import "./assets/styles/layout-madrid.css"
import "./assets/styles/theme-bluegray.css"
import "primeicons/primeicons.css"
import store from "./store"
const app = createApp(App);
app.use(store)
app.use(router)
app.use(PrimeVue)
app.use(ToastService)
app.component("InputText", InputText)
app.component("Password", Password)
app.component("Toast", Toast)
app.mount("#app")

