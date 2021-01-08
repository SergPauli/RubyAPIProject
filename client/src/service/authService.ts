import BaseService from "./baseService"
export default class AuthService extends BaseService {
  login(params: JSON) {
    return this.instance
      .post("sign_in", params, this.requestConfig)
      .then((response) => {
          if (response.status === 200) {            
            return response.data
          }                  
          throw new Error(response.data.message)       
        })
     
  }
  logout() {
    return this.instance.delete("sign_out", this.requestConfig).then((response) => response.data)      
  }
}
