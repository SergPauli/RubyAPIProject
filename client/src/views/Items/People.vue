<template>
  <div class="p-grid crud-demo" >
    <div class="p-col-12 " :style="{ height: '400px' }">      
        <DataTable
          ref="dt"
          :value="people"
          v-model:selection="selectedPeople"
          dataKey="id"
          :scrollable="true"
          scrollHeight="376px"
          :virtualRowHeight="virtualRowHeight"
          :lazy="true"
          @sort="onSort($event)"
          :first="first"
          :rows="rows"
          @rowSelect="onRowCheck" @rowUnselect="onRowCheck"
          :loading="loading"
          :virtualScroll="true"          
          @virtual-scroll="onVirtualScroll"
          :totalRecords="lazyTotalRecords"  
          class="p-datatable-sm"        
        >
          <template #header>
            <div class="table-header p-d-flex p-flex-column p-flex-md-row p-jc-md-between">
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

      <PersonDialog  @save="savePerson" @hide="hideDialog" />

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
</template>

<script>
import UniversalService from "@/service/universalService"
import PersonDialog from "@/components/Dialogs/Person/PersonDialog"
import { mapState } from "vuex"
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
      isSelected: true,
      filters: {},
      //contact:{data:"", type:null, description:""},
      //contactTypes: [{name:"Email", icon:"pi pi-envelope"},{name:"Phone", icon:"pi pi-phone"}, {name:"Fax",icon:"pi pi-print"} ], 
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
  created() {
    this.universalService = new UniversalService(this.$router)    
    this.$store.dispatch("setActionBarButtons", [
      {code:1, title: "Add new person", icon: "pi pi-plus", class: "p-button-success", disabled:false},
      {code:2, title: "Remove selected person", icon: "pi pi-trash", class: "p-button-danger", disabled:true},      
      {code:3, title: "Export selected person", icon: "pi pi-upload", class: "p-button-help", disabled:false},
    ]) 
    this.unwatch = this.$store.watch(
      (state, getters) => getters.btCode,
      (newValue, oldValue) => {    
       // console.log('newValue', newValue)   
        if (newValue == 1) {
          this.openNew()
          this.$store.dispatch("clickActionBarButton", 0)
        } else if (newValue == 2) {
          this.confirmDeleteSelected()
          this.$store.dispatch("clickActionBarButton", 0)
        } else if (newValue == 3) {
          this.exportCSV()
          this.$store.dispatch("clickActionBarButton", 0)
        }                 
      },
    ) 
  },
  mounted() {
    this.$store.dispatch("setPersonDialogData",{person: this.person, visible: this.personDialog, submitted: this.submitted})
    this.lazyParams = {
      first: 0,
      rows: this.$refs.dt.rows,
      sortField: null,
      sortOrder: null,
      filters: this.filters
    }
    this.getCount()       
  },
  beforeUnmount() {
    this.unwatch();
  },
  methods: {
    onSort(event) {
      this.lazyParams = event          
      this.loadChunk(this.lazyParams.first, this.rows * 2)
    },
    getContactName(person) {
      if (person.contacts === undefined || person.contacts.length == 0) return ""
      let result = person.contacts[0].data
      if (person.contacts.length > 1) result = result +"..." 
      return result
    },    
    openNew() {
      this.person = {contacts:[]}
      this.contacts = [] 
      this.submitted = false
      this.personDialog = true 
      this.$store.dispatch("setPersonDialogData",{person: this.person, visible: this.personDialog, submitted: this.submitted})     
    },
    hideDialog() {      
      this.personDialog = false
      this.submitted = false 
      this.$store.dispatch("setPersonDialogData",{person: this.person, visible: this.personDialog, submitted: this.submitted})           
    },
    savePerson(event) {
      this.submitted = true
      //console.log("permitted",JSON.stringify(this.request.permitted))
      Object.keys(event.request).forEach(key => {
        if (key!=="permitted" ) this.request.permitted.push(key)
      })      
      if (this.request.permitted.length > 0 ) {
        if (this.person.id) { 
          this.loading= true           
          const idx = this.people.findIndex(p=>p.id == this.person.id)                   
          this.universalService.edit(MODEL, this.person.id, event.request)
            .then((data) => {        
              this.loading = false
              this.$toast.add({severity: "success",summary: "Successful",detail: "Person Updated",life: 3000}) 
              //event.request = {permitted: []}              
              if (idx > 0) this.people[idx] = data                             
            }).catch((error)=>this.$store.dispatch("putMessage",{severity:"error", detail: error.message, summary:"Error" }))          
        } else {
          this.loading= true         
          event.request.include = "contacts"     
          this.universalService.create(MODEL, event.request)
            .then((data) => {        
              this.loading = false
              this.$toast.add({
                severity: "success",
                summary: "Successful",
                detail: "Person Added",
                life: 3000,
              }); 
              //this.request = {permitted: []} 
              //console.log('data',data)
              if (data.contacts===undefined) data.contacts=[]
              this.people.push(data) 
              this.lazyTotalRecords = this.lazyTotalRecords + 1                     
            }).catch((error)=>this.$store.dispatch("putMessage", 
            {severity:"error", detail: error.message, summary:"Error" }))
        }
        this.personDialog = false
        this.person = {}
        this.$store.dispatch("setPersonDialogData",{person: this.person, visible: this.personDialog, submitted: this.submitted})
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
      this.personDialog = true
      this.$store.dispatch("setPersonDialogData",{person: this.person, visible: this.personDialog, submitted: this.submitted})
    },
    confirmDeletePerson(person) {
      this.person = person
      this.deletePersonDialog = true
    },
    deletePerson() {
      this.loading= true              
      this.universalService.delete(MODEL, this.person.id)
            .then((data) => {        
              this.loading = false
              this.$toast.add({ severity: "success", summary: "Successful", detail: "Person removed", life: 3000 }) 
              this.request = {permitted: []}              
              this.people = this.people.filter((val) => val.id !== this.person.id)
              this.deletePersonDialog = false
              this.person = {}  
              this.lazyTotalRecords = this.lazyTotalRecords - 1                             
            }).catch((error)=>this.$store.dispatch("putMessage",{severity:"error", detail: error.message, summary:"Error person removing" }))      
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
      const  index =  this.lazyTotalRecords - this.rows      
      //console.log('first', this.first) 
      //console.log('event.first', event.first)
      if (this.first == event.first && event.first <  index) this.loadChunk(event.first, this.rows*2)
      this.first = event.first
    },    
    onRowCheck() {
      if ((!this.selectedPeople || !this.selectedPeople.length) != this.isSelected) {
        this.isSelected = !this.isSelected
        this.$store.dispatch("disableBtAction", {code:2, disabled: this.isSelected})
      }            
    },
  },
  computed: {    
    count() {
      return this.lazyTotalRecords
    },    
    ...mapState(['btCode'])        
  },
  components: {   
    PersonDialog
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

