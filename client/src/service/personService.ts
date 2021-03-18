import BaseService from "./baseService"
export default class PersonService extends BaseService {
  getPeople(params: JSON) {
    return this.instance.post("v1/universal_api/Person", params, this.requestConfig)
    .then((response) => {
      //console.log('response ', response)
      if (response.data.status === 200) return response.data.data
      throw new Error(response.data.message)
    })
  }               
  edit(id: string, person: JSON) {
    return this.instance.put("v1/universal_api/Person/" + id, person, this.requestConfig)
    .then((response) => {
      if (response.data.status === 200) return response.data.data                    
      throw new Error(response.data.message)
    })
  }
  create(person: JSON) {
    return this.instance.post("v1/universal_api/Person/add/", person, this.requestConfig)
    .then((response) => {
      if (response.data.status === 200) return response.data.data
      throw new Error(response.data.message)
    })
  }
}
