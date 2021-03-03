import BaseService from "./baseService"
export default class PersonService extends BaseService {
                 getPeople(params: JSON) {
                  return this.instance.post("v1/universal_api/Person", params, this.requestConfig).then((response) => {
                     if (response.status === 200) {
                       return response.data
                     }
                     throw new Error(response.data.message)
                   })
                 }
                 edit(id: string, person: JSON){
                  return this.instance
                    .put("v1/universal_api/Person/" + id, person, this.requestConfig)
                    .then((response) => {
                      if (response.status === 200) {
                        return response.data
                      }
                      throw new Error(response.data.message)
                    })
                 }                 
               }
