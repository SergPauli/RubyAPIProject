import { createApp } from "vue"
import App from "./App.vue"
import router from "./router"
import PrimeVue from "primevue/config"
import InputText from "primevue/inputtext"
import Password from "primevue/password"
import ToastService from "primevue/toastservice"
import Toast from "primevue/toast"
import Breadcrumb from "primevue/breadcrumb"
import Menu from "primevue/menu"
import Dialog from "primevue/dialog"
import DataTable from "primevue/datatable"
import Column from "primevue/column"
import Toolbar from "primevue/toolbar"
import Textarea from "primevue/textarea"
import Button from "primevue/button"
import FileUpload from "primevue/fileupload"
import Checkbox from "primevue/checkbox"
import ProgressSpinner from "primevue/progressspinner"
//import Chips from "primevue/chips"
import Tooltip from "@/components/Tooltip/Tooltip"
import "@/components/Tooltip/Tooltip.css"
import "./assets/styles/layout-madrid.css"
import "./assets/styles/theme-bluegray.css"
import "primeicons/primeicons.css"
import "primeflex/primeflex.css"
import "@/components/Tooltip/Tooltip.css"
import store from "./store"
const app = createApp(App);
app.use(store)
app.use(router)
app.use(PrimeVue)
app.use(ToastService)
app.directive("tooltip", Tooltip)
app.component("InputText", InputText)
app.component("Password", Password)
app.component("Toast", Toast)
app.component("Breadcrumb", Breadcrumb)
app.component("Menu", Menu)
app.component("Dialog", Dialog)
app.component("DataTable", DataTable)
app.component("Column", Column)
app.component("Toolbar", Toolbar)
app.component("Textarea", Textarea)
app.component("Button", Button)
app.component("FileUpload", FileUpload)
app.component("Checkbox", Checkbox)
app.component("ProgressSpinner", ProgressSpinner)
//app.component("Chips", Chips)
app.mount("#app")

