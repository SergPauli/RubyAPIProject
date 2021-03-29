import BaseService from "./baseService"
const baseUrl = "v1/universal_api/"

 
export default class UniversalService extends BaseService {
         index(model: string, params: JSON, fromLocalStore = false) {
           if (fromLocalStore) {
             const find = localStorage.getItem(model)
             if (find) return find
           }
           return this.instance.post(baseUrl + model, params, this.requestConfig).then((response) => {
             //console.log('response ', response)
             if (response.data.status === 200) {
               if (fromLocalStore) localStorage.setItem(model, response.data.data)
               return response.data.data
             }
             if (response.data.message) throw new Error(response.data.message)
           })
         }
         edit(model: string, id: string, data: JSON) {
           return this.instance.put(baseUrl + model + id, data, this.requestConfig).then((response) => {
             if (response.data.status === 200) return response.data.data
             if (response.data.message) throw new Error(response.data.message)
           })
         }
         create(model: string, data: JSON) {
           return this.instance.post(baseUrl + model + "add/", data, this.requestConfig).then((response) => {
             if (response.data.status === 200) return response.data.data
             if (response.data.message) throw new Error(response.data.message)
           })
         }
       }
