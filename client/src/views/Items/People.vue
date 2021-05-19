<template>
  <div class="p-grid crud">
    <div class="p-col-12 p-md-8">
      <DataTable
        ref="dt"
        :value="people"
        v-model:selection="selectedPeople"
        dataKey="id"
        :scrollable="true"
        :scrollHeight="divHeight - staticPartHeight + 'px'"
        :virtualRowHeight="virtualRowHeight"
        :lazy="true"
        @sort="onSort($event)"
        :first="first"
        :rows="rows"
        @rowSelect="onRowCheck"
        @rowUnselect="onRowCheck"
        :loading="loading"
        :virtualScroll="true"
        selectionMode="single"
        @virtual-scroll="onVirtualScroll"
        :totalRecords="lazyTotalRecords"
        class="p-datatable-sm p-shadow-3 widget-table-card"   
        :style="{ height: divHeight + 'px'}"   >        
        <Column field="id" header="ID" :headerStyle="{width: '4rem'}" :sortable="true" >
          <template #loading>
            <span class="loading-text"></span>
          </template>
        </Column>        
        <Column field="name" header="Name" :sortable="true">
          <template #loading>
            <span class="loading-text"></span>
          </template>
        </Column>
        <Column field="surname" header="Surname" :sortable="true">
          <template #loading>
            <span class="loading-text"></span>
          </template>
        </Column>
        <Column field="middlename" header="Middlename" :sortable="true">
          <template #loading>
            <span class="loading-text"></span>
          </template>
        </Column>
        <Column field="contacts" header="Contacts" class="p-d-none p-d-md-inline-flex">
          <template #loading>
            <span class="loading-text"></span>
          </template>
          <template #body="slotProps">
            {{ getContactName(slotProps.data) }}
          </template>
        </Column>        
        <template #footer> In total there are {{ lazyTotalRecords }} persons. </template>
      </DataTable>
    </div>
    <div class="p-col-12 p-md-4">
      <div class="card widget-user-card p-shadow-3" :style="{height: divHeight + 'px'}">
        <div class="user-card-header">
          <img
            src="../../assets/images/avatars/admin-ava.jpg"
            class="user-card-avatar"
            alt="diamond-layout"
          />
        </div>
        <div class="user-card-body">
          <div class="user-card-title">{{selectedPeople? selectedPeople.surname : ''}}</div>
          <div class="user-card-subtext">{{selectedPeople? selectedPeople.name : ''}} {{selectedPeople? selectedPeople.middlename : ''}}</div>
          <div class="p-grid user-card-stats">
            <div class="p-col-4">
              <i class="pi pi-users"></i>
              <div>14 Clients</div>
            </div>
            <div class="p-col-4">
              <i class="pi pi-bookmark"></i>
              <div>{{selectedPeople? selectedPeople.users.length : '0'}} accounts</div>
            </div>
            <div class="p-col-4">
              <i class="pi pi-check-square"></i>
              <div>6 Tasks</div>
            </div>
          </div>
          <button class="p-button p-component" style="width: 100%">
            <span class="p-button-label p-c">Assign</span>
          </button>
        </div>
      </div>
    </div>
    <PersonDialog @save="savePerson" @hide="hideDialog" />

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
  </div>
</template>

<script>
import UniversalService from "@/service/universalService";
import PersonDialog from "@/components/Dialogs/Person/PersonDialog";
import { mapState } from "vuex";
const MODEL = "Person/";
const fields = ["id", "name", "surname", "middlename", "description"];
export default {
  data() {
    return {
      divHeight: 366,
      staticPartHeight: 66,
      people: null,
      loading: false,
      personDialog: false,
      deletePersonDialog: false,      
      person: {},
      lazyParams: {},
      contacts: [],
      selectedPeople: null,      
      deleteDisabled: true,
      editDisabled: true,
      filters: {},
      request: { permitted: [] },
      filter: null,
      first: 0,
      rows: 12,
      submitted: false,
      lazyTotalRecords: 0,
      virtualRowHeight: 40,
    }
  },
  watch: {
    filter() {
      this.getCount()
    },
  },
  created() {
    this.divHeight = document.getElementById("contentDiv").offsetHeight + 21;
    this.universalService = new UniversalService(this.$router);
    this.$store.dispatch("setActionBarButtons", [
      {
        code: 1,
        title: "Add new person",
        icon: "pi pi-plus",
        class: "p-button-success",
        disabled: false,
      },
      {
        code: 4,
        title: "edit person",
        icon: "pi pi-pencil",
        class: "p-button-success",
        disabled: true,
      },
      {
        code: 2,
        title: "Remove selected person",
        icon: "pi pi-trash",
        class: "p-button-danger",
        disabled: true,
      },
      {
        code: 3,
        title: "Export selected person",
        icon: "pi pi-upload",
        class: "p-button-help",
        disabled: false,
      },
    ]);
    this.unwatch = this.$store.watch(
      (state, getters) => getters.btCode,
      (newValue, oldValue) => {
        // console.log('newValue', newValue)
        if (newValue == 1) {
          this.openNew();
          this.$store.dispatch("clickActionBarButton", 0);
        } else if (newValue == 2) {
          this.confirmDeletePerson(this.selectedPeople);
          this.$store.dispatch("clickActionBarButton", 0);
        } else if (newValue == 3) {
          this.exportCSV();
          this.$store.dispatch("clickActionBarButton", 0);
        } else if (newValue == 4) {
          this.editPerson(this.selectedPeople);
          this.$store.dispatch("clickActionBarButton", 0);
        }

      }
    );
  },
  mounted() {
    this.$store.dispatch("setPersonDialogData", {
      person: this.person,
      visible: this.personDialog,
      submitted: this.submitted,
    });
    this.lazyParams = {
      first: 0,
      rows: this.$refs.dt.rows,
      sortField: null,
      sortOrder: null,
      filters: this.filters,
    };
    this.getCount();
  },
  beforeUnmount() {
    this.unwatch();
  },
  methods: {
    onSort(event) {
      this.lazyParams = event;
      this.loadChunk(this.lazyParams.first, this.rows * 2);
    },
    getContactName(person) {
      if (person.contacts === undefined || person.contacts.length == 0) return "";
      let result = person.contacts[0].data;
      if (person.contacts.length > 1) result = result + "...";
      return result;
    },
    openNew() {
      this.person = { contacts: [] };
      this.contacts = [];
      this.submitted = false;
      this.personDialog = true;
      this.$store.dispatch("setPersonDialogData", {
        person: this.person,
        visible: this.personDialog,
        submitted: this.submitted,
      });
    },
    hideDialog() {
      this.personDialog = false;
      this.submitted = false;
      this.$store.dispatch("setPersonDialogData", {
        person: this.person,
        visible: false,
        submitted: false,
      });
    },
    savePerson(event) {
      this.submitted = true      
      this.request = event.request            
      Object.keys(this.request).forEach((key) => {
        if (key !== "permitted" ) this.request.permitted.push(key);
      })
      this.request.include = "1"
      this.request.select = fields
      if (this.request.permitted.length > 0) {
        if (this.person.id) {
          this.loading = true;
          const idx = this.people.findIndex((p) => p.id == this.person.id);
          this.universalService
            .edit(MODEL, this.person.id, this.request)
            .then((data) => {              
              this.$toast.add({
                severity: "success",
                summary: "Successful",
                detail: "Person Updated",
                life: 3000,
              })               
              console.log('data', data)           
              if (idx > 0) this.people[idx] = data
            })
            .catch((error) =>
              this.$store.dispatch("putMessage", {
                severity: "error",
                detail: error.message,
                summary: "Error",
              })
            ).finally(this.loading = false)
        } else {        
          this.universalService
            .create(MODEL, this.request)
            .then((data) => {              
              this.$toast.add({
                severity: "success",
                summary: "Successful",
                detail: "Person Added",
                life: 3000,
              })              
              console.log('data',data)
              if (data.contacts === undefined) data.contacts = [];
              this.people.push(data);
              this.lazyTotalRecords = this.lazyTotalRecords + 1;
            }).catch((error) =>
              this.$store.dispatch("putMessage", {
                severity: "error",
                detail: error.message,
                summary: "Error",
              })
            ).finally(this.loading = false)
        }
        this.personDialog = false;
        this.request = {permitted: []}        
        this.$store.dispatch("setPersonDialogData", {
          person: this.person,
          visible: this.personDialog,
          submitted: this.submitted,
        });
      } else {
        this.$toast.add({
          severity: "info",
          summary: "Decline",
          detail: "There is no changes",
          life: 3000,
        });
      }
    },
    editPerson(person) {
      this.person = { ...person };
      this.personDialog = true;
      this.$store.dispatch("setPersonDialogData", {
        person: this.person,
        visible: true,
        submitted: this.submitted,
      });
    },
    confirmDeletePerson(person) {
      this.person = person;
      this.deletePersonDialog = true;
    },
    deletePerson() {
      this.loading = true;
      this.universalService
        .delete(MODEL, this.person.id)
        .then((data) => {
          this.loading = false;
          this.$toast.add({
            severity: "success",
            summary: "Successful",
            detail: "Person removed",
            life: 3000,
          });
          this.request = { permitted: [] };
          this.people = this.people.filter((val) => val.id !== this.person.id);
          this.deletePersonDialog = false;
          this.person = {};
          this.selectedPeople = null;
          this.lazyTotalRecords = this.lazyTotalRecords - 1;
          this.onRowCheck()
        })
        .catch((error) =>
          this.$store.dispatch("putMessage", {
            severity: "error",
            detail: error.message,
            summary: "Error person removing",
          })
        );
    },
    exportCSV() {
      this.$refs.dt.exportCSV();
    },       
    getCount() {
      const params = {
        count: true,
        q: {},
      };
      if (this.filter) {
        params.q = { 'text_cont': this.filter };
      }
      if (this.lazyParams.sortField) {
        params.q.sorts = [
          this.lazyParams.sortField +
            (this.lazyParams.sortOrder == "1" ? " asc" : " desc"),
        ];
      }
      this.loading = true;
      this.universalService
        .index(MODEL, params)
        .then((data) => {
          this.loading = false;
          this.lazyTotalRecords = data;
          if (this.lazyTotalRecords - this.rows < 1) this.loadChunk(0, this.rows);
          else this.loadChunk(0, this.rows * 2);
        })
        .catch((error) =>
          this.$store.dispatch("putMessage", {
            severity: "error",
            detail: error.message,
            summary: "Error",
          })
        );
    },
    loadChunk(index, length) {
      const params = {
        select: fields,        
        q: {},
        include: "contacts",
        limit: length,
        offset: index,
      };
      if (this.filter) {
        params.q = { 'text_cont': this.filter };
      }
      if (this.lazyParams.sortField) {
        params.q.sorts = [
          this.lazyParams.sortField +
            (this.lazyParams.sortOrder == "1" ? " asc" : " desc"),
        ];
      }
      this.loading = true;
      this.universalService
        .index(MODEL, params)
        .then((data) => {
          //console.log(data)
          this.people = data;
          this.loading = false;
        })
        .catch((error) =>
          this.$store.dispatch("putMessage", {
            severity: "error",
            detail: error.message,
            summary: "Error",
          })
        );
    },
    onVirtualScroll(event) {
      const index = this.lazyTotalRecords - this.rows;
      //console.log("first", this.first);
      //console.log("event.first", event.first);
      if (this.first !== event.first && event.first < index)
        this.loadChunk(event.first, this.rows * 2);
      else this.people = this.people.concat();
      this.first = event.first;
    },
    onRowCheck() {      
      const newDeleteDisabled = !(this.selectedPeople && this.selectedPeople.users.length==0)
      if (newDeleteDisabled != this.deleteDisabled) {
        this.deleteDisabled = newDeleteDisabled        
        this.$store.dispatch("disableBtAction", { code: 2, disabled: this.deleteDisabled})
      }
      const newEditDisabled = !this.selectedPeople 
      if (newEditDisabled != this.editDisabled) {
        this.editDisabled = newEditDisabled        
        this.$store.dispatch("disableBtAction", { code: 4, disabled: this.editDisabled})
      }
    },
  },
  computed: {
    count() {
      return this.lazyTotalRecords;
    },
    ...mapState(["btCode"]),
  },
  components: {
    PersonDialog,
  },
};
</script>
<style>
.crud {
  padding: 0.5rem 0.5rem;
  margin: 0;
}
.widget-table-card {
    padding: 0px;
    border-radius: 3px;
    background: rgb(255, 255, 255);
    border: 1px solid rgb(223, 230, 238);
}
.p-datatable.p-datatable-sm .p-datatable-tbody > tr > td {
  padding: 0.2rem;
}
.p-fluid .p-inputtext {
  width: 100%;
}
.widget-user-card .user-card-header {    
  height: 100px;    
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
