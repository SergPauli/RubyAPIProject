import axios, { AxiosRequestConfig } from "axios"
import { Router } from "vue-router"
import store from "@/store"
export default class BaseService {
  requestConfig: AxiosRequestConfig = {
    baseURL: "http://localhost:5000/api/",
    headers: {
      common: {
        "Cache-Control": "no-cache, no-store, must-revalidate",
        Pragma: "no-cache",
        "Content-Type": "application/json",
        Accept: "application/json",
      },
    },
  }
  instance = axios.create(this.requestConfig)
  constructor(router: Router) {
    const token = localStorage.getItem("token")
    if (token) this.requestConfig.headers.common["Authorization"] = token
    this.instance.interceptors.response.use(
      function(response) {
        // Any status code that lie within the range of 2xx cause this function to trigger
        // Do something with response data
        if (response.data.status === 401) {
          console.log("error401 is catching ", response.data.error)
          store.dispatch("error401", response.data.error)
          router.push("/login");         
        }
        return response
      },
      function(error) {        
        // Any status codes that falls outside the range of 2xx cause this function to trigger
        // Do something with response error             
        return new Promise(function(resolve, reject) {                    
          throw error          
        })
      }
    )
  }
}
