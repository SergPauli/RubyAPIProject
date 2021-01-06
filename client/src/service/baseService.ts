import axios, { AxiosRequestConfig } from "axios"
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
  constructor() {
    const token = localStorage.getItem("token")
    if (token) this.requestConfig.headers.common["Authorization"] = token
    this.instance.interceptors.response.use(
      function(response) {
        // Any status code that lie within the range of 2xx cause this function to trigger
        // Do something with response data
        return response
      },
      function(error) {        
        // Any status codes that falls outside the range of 2xx cause this function to trigger
        // Do something with response error       
        return new Promise(function(resolve, reject) {
          if (error.message.includes("401") && error.config && !error.config.__isRetryRequest) {            
            store.dispatch("error401")            
          }
          throw error
        })
      }
    )
  }
}
