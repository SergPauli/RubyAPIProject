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
          <Column  field="contacts" header="Contacts" class="p-d-none p-d-md-inline-flex"
          > <template #body="slotProps">
              {{slotProps.data.contacts[0].data}}
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
            In total there are {{people ? people.length : 0 }} persons.
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
        <div class="p-field p-grid">
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
        <div class="p-field p-grid">
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
        <div class="p-field p-grid">
          <label for="middlename">Middlename</label>
          <InputText
            id="middlename"
            v-tooltip.top="'Enter your username'"
            v-model.trim="person.middlename"
            @change="request.middlename = person.middlename"
            @keyup.enter="onNext('middlename','description')"                        
            :class="{ 'p-invalid': submitted && !person.middlename }"
          />
          <small class="p-invalid" v-if="submitted && !person.middlename"
            >Middlename is required.</small
          >
        </div>
        <div class="p-field p-grid">
          <label for="description">Description</label>
          <Textarea
            id="description"
            v-tooltip.top="'Enter your username'"
            v-model="person.description"
            @change="request.description = person.description"
            @keyup.enter="onNext('description','Save')"
            required="true"
            rows="3"
            cols="20" 
          />
        </div>
        <div class="p-field p-grid"> 
          <label for="contacts">Контакты</label>
          <Button icon="pi pi-plus" class="p-button  p-button-rounded p-mr-2 p-mb-2 p-button-success" :style="{margin:'0 0.5rem'}"/>            
          <div  class="p-d-flex p-ai-center" v-for="(contact) in person.contacts" :key="contact.id">	          
	          <Chip :label="contact.data" :icon="contactIcon(contact.type)" 
            removable v-tooltip.top="contact.description" @remove="onRemoveContact(contact.id)"/>
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
import PersonService from "@/service/personService"
import Chip from "@/components/Chip/Chip.vue"
export default {
  data() {
    return {
      people: null,
      loading: false,
      personDialog: false,
      deletePersonDialog: false,
      deletePeopleDialog: false,
      person: {},
      contacts: [],
      selectedPeople: null,
      filters: {},
      request: {permitted: []},
      filter: null,
      first: 0,
      rows: 6,
      submitted: false,
      lazyTotalRecords: 0,
      virtualRowHeight: 48
    };
  },  
  watch: {
    filter(){      
      this.getCount()
    }
  },
  personService: null,
  created() {
    this.personService = new PersonService();
  },
  mounted() {
    this.getCount()       
  },
  methods: {
    onRemoveContact(id){      
      const contactsAttributes= [] 
      const destroy = {_destroy : '1'}  
      this.person.contacts.filter(contact => contact.id === id)
      .map(contact=>{ destroy.id = contact.id
                      contactsAttributes.push(destroy)})         
      if (this.request['contacts_attributes']) this.request['contacts_attributes'].concat(contactsAttributes)
      else  this.request['contacts_attributes'] = contactsAttributes
      this.person.contacts = this.person.contacts.filter(contact => contact.id !== id) 
    },
    onAddContact(params){      
      const contact = {
        data: params.value[params.value.length - 1],        
      } 
      const regexPhone ="^\\+\\d{2}\\(\\d{3}\\)\\d{3}-\\d{2}-\\d{2}$"
      const regexMail = "/^([a-z0-9_-]+\\.)*[a-z0-9_-]+@[a-z0-9_-]+(\\.[a-z0-9_-]+)*\\.[a-z]{2,6}$"
      if (contact.data.match(regexPhone)!==null || contact.data.includes("tel:")) {               
          if (this.request.phones_attributes) this.request.contacts_attributes.push(contact)
          else  this.request['phones_attributes'] = [contact]
      } else if (contact.data.match(regexMail)!==null) {          
          if (this.request.emails_attributes) this.request.contacts_attributes.push(contact)
          else  this.request['emails_attributes'] = [contact]
      } else if (contact.data.includes("fax:")) {          
          if (this.request.faxes_attributes) this.request.contacts_attributes.push(contact)
          else  this.request['faxes_attributes'] = [contact]
      } 
      this.person.contacts.push(contact)     
    },
    onNext(currentId,nextId) {
      document.getElementById(currentId).blur(); 
      document.getElementById(nextId).focus();
    },    
    openNew() {
      this.person = {}
      this.contacts = [] 
      this.submitted = false
      this.personDialog = true      
    },
    hideDialog() {      
      this.personDialog = false;
      this.submitted = false;
    },
    savePerson() {
      this.submitted = true;
      //console.log("permitted",JSON.stringify(this.request.permitted))
      Object.keys(this.request).forEach(key => {
        if (key!=="permitted") this.request.permitted.push(key)
      })      
      if (this.request.permitted.length > 0 ) {
        if (this.person.id) { 
          this.loading= true              
          this.personService.edit(this.person.id, this.request)
            .then((data) => {        
              this.loading = false
              this.$toast.add({
                severity: "success",
                summary: "Successful",
                detail: "Person Updated",
                life: 3000,
              }); 
              this.request = {permitted: []}                  
            }).catch((error)=>this.$store.dispatch("putMessage", {severity:"error", detail: error.message, summary:"Error" }));          
        } else {
          this.person.id = this.createId();
          this.person.image = "person-placeholder.svg";
          this.people.push(this.person);
          this.$toast.add({
            severity: "success",
            summary: "Successful",
            detail: "person Created",
            life: 3000,
          });
        }
        this.personDialog = false;
        this.person = {};
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
      });
    },
    findIndexById(id) {
      let index = -1;
      for (let i = 0; i < this.people.length; i++) {
        if (this.people[i].id === id) {
          index = i;
          break;
        }
      }
      return index;
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
      this.$refs.dt.exportCSV();
    },
    confirmDeleteSelected() {
      this.deletePeopleDialog = true;
    },
    deleteSelectedPeople() {
      this.people = this.people.filter((val) => !this.selectedPeople.includes(val));
      this.deletePeopleDialog = false;
      this.selectedPeople = null;
      this.$toast.add({
        severity: "success",
        summary: "Successful",
        detail: "People Deleted",
        life: 3000,
      });
    },
    getCount() {
       const params = {        
       count: true,
       q:{},
      }
      if (this.filter) {        
        params.q={'text_cont':this.filter}
      }
      this.loading= true
      this.personService.getPeople(params)
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
      this.loading= true
      this.personService.getPeople(params)
      .then((data) => {
        console.log(data)
        this.people = data
        this.loading = false
        this.lazyTotalRecords = this.people.length
      })
      .catch((error)=>this.$store.dispatch("putMessage", {severity:"error", detail: error.message, summary:"Error" }));
    },
    onVirtualScroll(event) {      
      if (event.first === this.lazyTotalRecords - this.rows) this.loadChunk(event.first, this.rows)
      else  this.loadChunk(event.first, event.rows);      
      
    },
    contactIcon(type){
      switch (type) {
        case "Email": return "pi pi-envelope"
        case "Phone": return "pi pi-phone"
      }  
    }
  },
  computed: {
    
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

</style>

