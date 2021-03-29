<template>
  <div class="p-grid crud-demo">
    <div class="p-col-12">
      <div class="card" :style="{ height: '500px' }">
        <Toolbar class="p-mb-4">
          <template #left>
            <Button icon="pi pi-plus" class="p-button-success p-mr-2" @click="openNew" />
            <Button
              icon="pi pi-trash"
              class="p-button-danger"
              @click="confirmDeleteSelected"
              :disabled="!selectedPeople || !selectedPeople.length"
            />
          </template>
          <template #right>
            <FileUpload
              mode="basic"
              accept="image/*"
              :maxFileSize="1000000"
              label="Import"
              chooseLabel="Import"
              class="p-mr-2 p-d-inline-block"
            />
            <Button
              label="Export"
              icon="pi pi-upload"
              class="p-button-help"
              @click="exportCSV($event)"
            />
          </template>
        </Toolbar>

        <DataTable
          ref="dt"
          :value="people"
          v-model:selection="selectedPeople"
          dataKey="id"
          :scrollable="true"
          scrollHeight="300px"
          :virtualRowHeight="virtualRowHeight"
          :lazy="true"
          @sort="onSort($event)"
          :first="first"
          :rows="rows"
          :loading="loading"
          :virtualScroll="true"          
          @virtual-scroll="onVirtualScroll"
          :totalRecords="lazyTotalRecords"  
          class="p-datatable-sm"        
        >
          <template #header>
            <div
              class="table-header p-d-flex p-flex-column p-flex-md-row p-jc-md-between"
            >
              <h5 class="p-m-0">Manage People</h5>
              <span class="p-input-icon-left">
                <i class="pi pi-search" />
                <InputText v-model="filter" placeholder="Search..." />
              </span>
            </div>
          </template>
          <Column
            selectionMode="multiple"
            headerStyle="width: 3rem"
            :exportable="false"
          />
          <Column field="id" header="ID" :sortable="true"> <template #loading>
                <span class="loading-text"></span>
            </template></Column>
          <Column field="name" header="Name" :sortable="true"> <template #loading>
                <span class="loading-text"></span>
            </template></Column>
          <Column field="surname" header="Surname" :sortable="true"> <template #loading>
                <span class="loading-text"></span>
            </template></Column>
          <Column field="middlename" header="Middlename" :sortable="true"> <template #loading>
                <span class="loading-text"></span>
            </template></Column>
          <Column  field="contacts" header="Contacts" class="p-d-none p-d-md-inline-flex"> 
            <template #body="slotProps">
              {{getContactName(slotProps.data)}}
            </template>
          </Column>
          <Column :exportable="false">
            <template #body="slotProps">
              <Button
                icon="pi pi-pencil"
                class="p-button-rounded p-button-success p-mr-2 p-button-sm p-button-text"
                @click="editPerson(slotProps.data)"
              />
              <Button
                icon="pi pi-trash"
                class="p-button-rounded p-button-danger p-button-sm p-button-text"
                @click="confirmDeletePerson(slotProps.data)"
              />
            </template>
          </Column>
          <template #footer>
            In total there are {{lazyTotalRecords}} persons.
          </template>
        </DataTable>
      </div>

      <Dialog
        id="personDialog"
        v-model:visible="personDialog"
        :style="{ width: '450px' }"
        header="Person Details"
        :modal="true"
        class="p-fluid"
      >
      <div class="p-formgrid p-grid">
        <div class="p-field  p-col-12 p-md-6">
          <label for="name">Name</label>
          <InputText
            id="name"
            v-model.trim="person.name"
            @change="request.name = person.name"
            @keyup.enter="onNext('name','surname')"
            required="true"
            autofocus
            :class="{ 'p-invalid': submitted && !person.name }"
          />
          <small class="p-invalid" v-if="submitted && !person.name"
            >Name is required.</small
          >
        </div>
        <div class="p-field  p-col-12 p-md-6">
          <label for="surname">Surname</label>
          <InputText
            id="surname"
            v-model.trim="person.surname"
            @change="request.surname = person.surname"
            @keyup.enter="onNext('surname','middlename')"
            required="true"            
            :class="{ 'p-invalid': submitted && !person.surname }"
          />
          <small class="p-invalid" v-if="submitted && !person.surname"
            >Surname is required.</small
          >
        </div>
      
        <div class="p-field p-col-12">
          <label for="middlename">Middlename</label>
          <InputText
            id="middlename"            
            v-model.trim="person.middlename"
            @change="request.middlename = person.middlename"
            @keyup.enter="onNext('middlename','contactData')"                        
            :class="{ 'p-invalid': submitted && !person.middlename }"
          />
          <small class="p-invalid" v-if="submitted && !person.middlename"
            >Middlename is required.</small
          >
        </div>
        <div class="p-field p-col-12"  > 
          <label for="contactData">Contacts list:</label>           
          <div class="p-grid " :style="{paddingTop: '0.6rem', background: 'rgb(233 245 249)' }">
            <div class="p-field p-col-12 p-md-7">                          
              <InputText id="contactData" type="text" @keyup.enter="onNext('contactData','contactDescription')"  v-model.trim="contact.data" placeholder="New contact" />
            </div>
            <div class="p-field p-col-12 p-md-5">              
              <Dropdown id="contactType"  v-model="contact.type" :showClear="true"
              :options="contactTypes" optionLabel="name" 
              placeholder="Select type" >
              <template #value="slotProps">
                <div class="contact-item" v-if="slotProps.value">
                  <span :class="slotProps.value.icon" ></span>
                  <div class="contact-item-value">{{slotProps.value.name}}</div>
                </div>
                <span v-else>{{slotProps.placeholder}} </span>
              </template>
              <template #option="slotProps">
              <div class="contact-item">
                <span :class="slotProps.option.icon" ></span>
                <div class="contact-item-value">{{slotProps.option.name}}</div>
              </div>
              </template>
              </Dropdown>
            </div>
            <div class="p-field p-col-8 p-md-10">              
              <InputText id="contactDescription" @keyup.enter="onNext('contactDescription','bt_add')"   type="text" v-model.trim="contact.description" placeholder="New contact description" />
            </div>
            <div class="p-field p-col-4 p-md-1">
              <Button id="bt_add" icon="pi pi-plus" v-tooltip.top="'Add new contact'" 
              class="p-button  p-mr-2 p-mb-2 p-button-success" :style="{margin:'0 -0.5rem'}"
              @click="onAddContact" :disabled="isValidContact"/>            
            </div>  
            <div  class="p-field  p-ai-center  p-col-12">	          
	            <Chip v-for="(contact) in person.contacts" :label="contact.data" :icon="contactIcon(contact.type)" :link="contactLinc(contact)"   :key="contact.data"
              removable v-tooltip.top="contact.description" @remove="onRemoveContact(contact)"/>
            </div>
          </div>  
        </div>  
        <div class="p-field p-col-12">
          <label for="description">Description</label>
          <Textarea
            id="description"            
            v-model="person.description"
            @change="request.description = person.description"
            @keyup.enter="onNext('description','Save')"
            required="true"
            rows="2"
            cols="40" 
          />
        </div> 
      </div>        
        <template #footer>
          <Button
            label="Cancel"
            icon="pi pi-times"
            class="p-button-text p-button-info"
            @click="hideDialog"
          />
          <Button id="Save"
            label="Save"
            icon="pi pi-check"
            class="p-button-text p-button-success"
            @click="savePerson"
          />
        </template>
      </Dialog>

      <Dialog
        v-model:visible="deletePersonDialog"
        :style="{ width: '450px' }"
        header="Confirm"
        :modal="true"
      >
        <div class="confirmation-content">
          <i class="pi pi-exclamation-triangle p-mr-3" style="font-size: 2rem" />
          <span v-if="person"
            >Are you sure you want to delete <b>{{ person.name }}</b
            >?</span
          >
        </div>
        <template #footer>
          <Button
            label="No"
            icon="pi pi-times"
            class="p-button-text p-button-info"
            @click="deletePersonDialog = false"
          />
          <Button
            label="Yes"
            icon="pi pi-check"
            class="p-button-text p-button-danger"
            @click="deletePerson"
          />
        </template>
      </Dialog>

      <Dialog
        v-model:visible="deletePeopleDialog"
        :style="{ width: '450px' }"
        header="Confirm"
        :modal="true"
      >
        <div class="confirmation-content">
          <i class="pi pi-exclamation-triangle p-mr-3" style="font-size: 2rem" />
          <span v-if="person">Are you sure you want to delete the selected People?</span>
        </div>
        <template #footer>
          <Button
            label="No"
            icon="pi pi-times"
            class="p-button-text p-button-info"
            @click="deletePeopleDialog = false"
          />
          <Button
            label="Yes"
            icon="pi pi-check"
            class="p-button-text p-button-danger"
            @click="deleteSelectedPeople"
          />
        </template>
      </Dialog>
    </div>
  </div>
</template>

<script>
import UniversalService from "@/service/universalService"
import Chip from "@/components/Chip/Chip.vue"
const regexPhone =/\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/;
const regexPhone2 =/\(?\+[0-9]{1,3}\)? ?-?[0-9]{1,3} ?-?[0-9]{3,5} ?-?[0-9]{4}( ?-?[0-9]{3})? ?(\w{1,10}\s?\d{1,6})?/;
const regexMail = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
const MODEL = "Person/"
export default {
  data() {
    return {
      people: null,
      loading: false,
      personDialog: false,
      deletePersonDialog: false,
      deletePeopleDialog: false,
      person: {},
      lazyParams: {},
      contacts: [],
      selectedPeople: null,
      filters: {},
      contact:{data:"", type:null, description:""},
      contactTypes: [{name:"Email", icon:"pi pi-envelope"},{name:"Phone", icon:"pi pi-phone"}, {name:"Fax",icon:"pi pi-print"} ], 
      request: {permitted: []},
      filter: null,
      first: 0,
      rows: 8,
      submitted: false,
      lazyTotalRecords: 0,
      virtualRowHeight: 48
    }
  },  
  watch: {
    filter(){      
      this.getCount()
    }
  },
  personService: null,
  created() {
    this.universalService = new UniversalService(this.$router)
  },
  mounted() {
    this.lazyParams = {
      first: 0,
      rows: this.$refs.dt.rows,
      sortField: null,
      sortOrder: null,
      filters: this.filters
    }
    this.getCount()       
  },
  methods: {
    onSort(event) {
      this.lazyParams = event
      console.log('lazyParams', this.lazyParams)      
      this.loadChunk(this.lazyParams.first, this.rows * 2)
    },
    getContactName(person) {
      if (person.contacts === undefined || person.contacts.length == 0) return ""
      let result = person.contacts[0].data
      if (person.contacts.length > 1) result = result +"..." 
      return result
    },
    onRemoveContact(contact){      
      const contactsAttributes= [] 
      const destroy = {_destroy : '1'}  
      if (contact.id) {
        this.person.contacts.filter(c => contact.id === c.id)
            .map(d=>{ destroy.id = d.id
                      contactsAttributes.push(destroy)})         
            if (this.request['contacts_attributes']) this.request['contacts_attributes'].concat(contactsAttributes)
            else  this.request['contacts_attributes'] = contactsAttributes
            this.person.contacts = this.person.contacts.filter(c => contact.id !== c.id)
      } else Object.keys(this.request).filter(key => key.includes("_attributes"))
        .forEach(key => {
          this.request[key] = this.request[key].filter(e=>e.data != contact.data)
          if (this.request[key]===[]) this.request.permitted = this.request.permitted.filter(e=>e != key)
        })            
    },
    onAddContact() {      
      const newContact = {
        data: this.contact.data, description: this.contact.description      
      }       
      if ((this.contact.type && this.contact.type.name==="Phone") || regexPhone.test(newContact.data) || regexPhone2.test(newContact.data) || newContact.data.includes("tel:")) {               
          if (this.request.phones_attributes) this.request.phones_attributes.push(newContact)
          else  this.request['phones_attributes'] = [newContact]
          if (this.contact.type === null) newContact.type = "Phone"
      } else if ((this.contact.type && this.contact.type.name==="Email") || regexMail.test(newContact.data)) {          
          if (this.request.emails_attributes) this.request.emails_attributes.push(newContact)
          else  this.request['emails_attributes'] = [newContact]
          if (this.contact.type === null) newContact.type = "Email"
      } else if ((this.contact.type && this.contact.type.name==="Fax")) {          
          if (this.request.faxes_attributes) this.request.faxes_attributes.push(newContact)
          else  this.request['faxes_attributes'] = [newContact]          
      } 
      if (newContact.type === undefined && this.contact.type) newContact.type = this.contact.type.name
      this.person.contacts.push(newContact) 
      this.contact =  {data:"", type:null, description:""}   
    },
    onNext(currentId,nextId) {
      document.getElementById(currentId).blur() 
      document.getElementById(nextId).focus()
    },
       
    openNew() {
      this.person = {contacts:[]}
      this.contacts = [] 
      this.submitted = false
      this.personDialog = true      
    },
    hideDialog() {      
      this.personDialog = false
      this.submitted = false
    },
    savePerson() {
      this.submitted = true
      //console.log("permitted",JSON.stringify(this.request.permitted))
      Object.keys(this.request).forEach(key => {
        if (key!=="permitted" ) this.request.permitted.push(key)
      })      
      if (this.request.permitted.length > 0 ) {
        if (this.person.id) { 
          this.loading= true           
          const idx = this.people.findIndex(p=>p.id == this.person.id)                   
          this.universalService.edit(MODEL, this.person.id, this.request)
            .then((data) => {        
              this.loading = false
              this.$toast.add({
                severity: "success",
                summary: "Successful",
                detail: "Person Updated",
                life: 3000,
              }); 
              this.request = {permitted: []}              
              if (idx > 0) this.people[idx] = data                             
            }).catch((error)=>this.$store.dispatch("putMessage", 
            {severity:"error", detail: error.message, summary:"Error" }))          
        } else {
          this.loading= true              
          this.universalService.create(MODEL, this.request)
            .then((data) => {        
              this.loading = false
              this.$toast.add({
                severity: "success",
                summary: "Successful",
                detail: "Person Added",
                life: 3000,
              }); 
              this.request = {permitted: []} 
              if (data.contacts===undefined) data.contacts=[]
              this.people.push(data)                 
            }).catch((error)=>this.$store.dispatch("putMessage", 
            {severity:"error", detail: error.message, summary:"Error" }))
        }
        this.personDialog = false
        this.person = {}
      } else {
        this.$toast.add({
            severity: "info",
            summary: "Decline",
            detail: "There is no changes",
            life: 3000,
          })
      }
    },    
    editPerson(person) {
      this.person = { ...person }  
      this.contacts = []    
      this.person.contacts.forEach(contact =>{this.contacts.push(contact.data)}) 
      this.personDialog = true
    },
    confirmDeletePerson(person) {
      this.person = person
      this.deletePersonDialog = true
    },
    deletePerson() {
      this.people = this.people.filter((val) => val.id !== this.person.id)
      this.deletePersonDialog = false
      this.person = {}
      this.$toast.add({
        severity: "success",
        summary: "Successful",
        detail: "person Deleted",
        life: 3000,
      })
    },
    findIndexById(id) {
      let index = -1;
      for (let i = 0; i < this.people.length; i++) {
        if (this.people[i].id === id) {
          index = i
          break
        }
      }
      return index
    },
    createId() {
      let id = "";
      const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      for (let i = 0; i < 5; i++) {
        id += chars.charAt(Math.floor(Math.random() * chars.length));
      }
      return id;
    },
    exportCSV() {
      this.$refs.dt.exportCSV()
    },
    confirmDeleteSelected() {
      this.deletePeopleDialog = true
    },
    deleteSelectedPeople() {
      this.people = this.people.filter((val) => !this.selectedPeople.includes(val))
      this.deletePeopleDialog = false
      this.selectedPeople = null
      this.$toast.add({
        severity: "success",
        summary: "Successful",
        detail: "People Deleted",
        life: 3000,
      })
    },
    getCount() {
       const params = {        
       count: true,
       q:{},
      }
      if (this.filter) {        
        params.q={'text_cont':this.filter}
      }
      if (this.lazyParams.sortField) {
        params.q.sorts = [this.lazyParams.sortField + (this.lazyParams.sortOrder == '1' ? ' asc' : ' desc')]
      }
      this.loading= true
      this.universalService.index(MODEL, params)
      .then((data) => {        
        this.loading = false
        this.lazyTotalRecords = data        
        if ((this.lazyTotalRecords - this.rows) < 1) this.loadChunk(0, this.rows)
        else  this.loadChunk(0, this.rows * 2)  
      })
      .catch((error)=>this.$store.dispatch("putMessage", {severity:"error", detail: error.message, summary:"Error" }));
    },
    loadChunk(index, length) {      
      const params = {
        select: ["id", "name", "surname", "middlename", "description"], 
        //extselect: ["contacts.id","contacts.data"],
        q:{}, 
        include: "contacts",      
        limit: length,
        offset: index,
      }
      if (this.filter) {        
        params.q={'text_cont': this.filter}
      }
      if (this.lazyParams.sortField) {
        params.q.sorts = [this.lazyParams.sortField + (this.lazyParams.sortOrder == '1' ? ' asc' : ' desc')] 
      }
      this.loading= true
      this.universalService.index(MODEL, params)
      .then((data) => {
        //console.log(data)
        this.people = data
        this.loading = false        
      })
      .catch((error)=>this.$store.dispatch("putMessage", 
      {severity:"error", detail: error.message, summary:"Error" }))
    },
    onVirtualScroll(event) { 
      const  index =   this.lazyTotalRecords - this.rows      
      //console.log('first', this.first) 
      //console.log('event.first', event.first)
      if (this.first == event.first && event.first <  index) this.loadChunk(event.first, this.rows*2)
      this.first = event.first
    },
    contactIcon(type) {
      return this.contactTypes.find(el => el.name===type).icon       
    },
    contactLinc(contact) {
      if (contact.data && contact.type) {
        if (contact.type==="Email") return "mailto:"+contact.data
        else if(contact.type==="Phone") return "tel:"+contact.data
      } else return false            
    }

  },
  computed: {
    isValidContact() {
      return !(this.contact.data && (this.contact.type || (regexPhone.test(this.contact.data) 
      || regexPhone2.test(this.contact.data)  || regexMail.test(this.contact.data))))
    }, 
  },
  components: {   
    Chip
  }, 
  
}
</script>

<style>
.p-fluid .p-inputtext {
  width: 100%;
}
.p-checkbox {
  display: inline-flex;
  cursor: pointer;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
  vertical-align: bottom;
}
.p-hidden-accessible {
  border: 0;
  clip: rect(0 0 0 0);
  height: 1px;
  margin: -1px;
  overflow: hidden;
  padding: 0;
  position: absolute;
  width: 1px;
}
.p-input-filled .table-header .p-inputtext {
  background: rgb(255, 255, 255);
}
.p-input-icon-left,
.p-input-icon-right {
  position: relative;
  display: inline-block;
}
.p-input-icon-left > i,
.p-input-icon-right > i {
  position: absolute;
  top: 50%;
  margin-top: -0.5rem;
}
.p-button {
  margin: 0;
  display: inline-flex;
  cursor: pointer;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
  align-items: center;
  vertical-align: bottom;
  text-align: center;
  overflow: hidden;
  position: relative;
}

.p-button-icon-only .p-button-label {
  visibility: hidden;
  width: 0;
  flex: 0 0 auto;
}
.p-button-icon-only {
  justify-content: center;
}
.confirmation-content {
  display: flex;
  align-items: center;
  justify-content: center;
}
.loading-text {
    display: block;
    background-color: #f1f1f1;
    min-height: 19px;
    animation: pulse 1s infinite ease-in-out;
    text-indent: -99999px;
    overflow: hidden;
}
.contact-item {
  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
  -webkit-box-align: center;
  -ms-flex-align: center;
  align-items: center;
  color: #055160;
}
.contact-item .contact-item-value {  
  margin-left: 0.4rem;
  color: #565e5d;
}

</style>

