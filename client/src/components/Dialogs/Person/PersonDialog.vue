<template>
  <Dialog
    id="personDialog"
    v-model:visible="visible"
    :style="{ width: '450px' }"
    header="Person Details"
    :modal="true"
    class="p-fluid"
    :key="componentKey"
  >
    <div class="p-formgrid p-grid">
      <div class="p-field p-col-12 p-md-6">
        <label for="name">Name</label>
        <InputText
          id="name"
          v-model.trim="pers.name"
          @change="request.name = pers.name"
          @keyup.enter="onNext('name', 'surname')"
          required="true"
          autofocus
          :class="{ 'p-invalid': submitted && !pers.name }"
        />
        <small class="p-invalid" v-if="submitted && !pers.name"
          >Name is required.</small
        >
      </div>
      <div class="p-field p-col-12 p-md-6">
        <label for="surname">Surname</label>
        <InputText
          id="surname"
          v-model.trim="pers.surname"
          @change="request.surname = pers.surname"
          @keyup.enter="onNext('surname', 'middlename')"
          required="true"
          :class="{ 'p-invalid': submitted && !pers.surname }"
        />
        <small class="p-invalid" v-if="submitted && !pers.surname"
          >Surname is required.</small
        >
      </div>

      <div class="p-field p-col-12">
        <label for="middlename">Middlename</label>
        <InputText
          id="middlename"
          v-model.trim="pers.middlename"
          @change="request.middlename = pers.middlename"
          @keyup.enter="onNext('middlename', 'contactData')"
        />
      </div>
      <div class="p-field p-col-12">
        <label for="contactData">Contacts list:</label>
        <div
          class="p-grid"
          :style="{ paddingTop: '0.6rem', background: 'rgb(233 245 249)' }"
        >
          <div class="p-field p-col-12 p-md-7">
            <InputText
              id="contactData"
              type="text"
              @keyup.enter="onNext('contactData', 'contactDescription')"
              v-model.trim="contact.data"
              placeholder="New contact"
            />
          </div>
          <div class="p-field p-col-12 p-md-5">
            <Dropdown
              id="contactType"
              v-model="contact.type"
              :showClear="true"
              :options="contactTypes"
              optionLabel="name"
              placeholder="Select type"
            >
              <template #value="slotProps">
                <div class="contact-item" v-if="slotProps.value">
                  <span :class="slotProps.value.icon"></span>
                  <div class="contact-item-value">{{ slotProps.value.name }}</div>
                </div>
                <span v-else>{{ slotProps.placeholder }} </span>
              </template>
              <template #option="slotProps">
                <div class="contact-item">
                  <span :class="slotProps.option.icon"></span>
                  <div class="contact-item-value">{{ slotProps.option.name }}</div>
                </div>
              </template>
            </Dropdown>
          </div>
          <div class="p-field p-col-8 p-md-10">
            <InputText
              id="contactDescription"
              @keyup.enter="onNext('contactDescription', 'bt_add')"
              type="text"
              v-model.trim="contact.description"
              placeholder="New contact description"
            />
          </div>
          <div class="p-field p-col-4 p-md-1">
            <Button
              id="bt_add"
              icon="pi pi-plus"
              v-tooltip.top="'Add new contact'"
              class="p-button p-mr-2 p-mb-2 p-button-success"
              :style="{ margin: '0 -0.5rem' }"
              @click="onAddContact"
              :disabled="isValidContact"
            />
          </div>
          <div class="p-field p-ai-center p-col-12">
            <Chip
              v-for="contact in pers.contacts"
              :label="contact.data"
              :icon="contactIcon(contact.type)"
              :link="contactLinc(contact)"
              :key="contact.data"
              removable
              v-tooltip.top="contact.description"
              @remove="onRemoveContact(contact)"
            />
          </div>
        </div>
      </div>
      <div class="p-field p-col-12">
        <label for="description">Description</label>
        <Textarea
          id="description"
          v-model="pers.description"
          @change="request.description = pers.description"
          @keyup.enter="onNext('description', 'Save')"
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
      <Button
        id="Save"
        label="Save"
        icon="pi pi-check"
        class="p-button-text p-button-success"
        @click="savePerson"
      />
    </template>
  </Dialog>
</template>
<script>
const contactTypes = [
  { name: "Email", icon: "pi pi-envelope" },
  { name: "Phone", icon: "pi pi-phone" },
  { name: "Fax", icon: "pi pi-print" },
]
const regexPhone =/\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/;
const regexPhone2 =/\(?\+[0-9]{1,3}\)? ?-?[0-9]{1,3} ?-?[0-9]{3,5} ?-?[0-9]{4}( ?-?[0-9]{3})? ?(\w{1,10}\s?\d{1,6})?/;
const regexMail = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
import Chip from "@/components/Chip/Chip.vue"
export default {
  emits: ["save", "hide"],  
  data() {  
    const conts = []    
    if (this.$store.state.personDialog.person.contacts) this.$store.state.personDialog.person.contacts.forEach(contact =>{conts.push(contact.data)})      
    return {
      contactTypes: contactTypes,
      visible: this.$store.state.personDialog.visible,  
      pers: this.$store.state.personDialog.person,
      submitted: this.$store.state.personDialog.submitted,  
      contacts: conts,
      request: { permitted: [] },
      contact: { data: "", type: null, description: "" },
      componentKey: 0,
    };
  },
  mounted() {
    this.$store.subscribe((mutation, state) => {      
      switch (mutation.type) {
        case "setPersonDialog":
          // Update your component with new state data          
          this.forceRerender()
          break;        
      }
    });
  },
  methods: {
    hideDialog(event) {
      //this.visible = false;
      this.$emit("hide", event);
    },
    savePerson(event) {
      //this.visible = false;
      event.request = this.request;
      this.$emit("save", event);
    },
    onRemoveContact(contact) {
      const contactsAttributes = [];
      const destroy = { _destroy: "1" };
      if (contact.id) {
        this.pers.contacts
          .filter((c) => contact.id === c.id)
          .map((d) => {
            destroy.id = d.id;
            contactsAttributes.push(destroy);
          });
        if (this.request["contacts_attributes"])
          this.request["contacts_attributes"].concat(contactsAttributes);
        else this.request["contacts_attributes"] = contactsAttributes;
        this.pers.contacts = this.pers.contacts.filter((c) => contact.id !== c.id);
      } else
        Object.keys(this.request)
          .filter((key) => key.includes("_attributes"))
          .forEach((key) => {
            this.request[key] = this.request[key].filter((e) => e.data != contact.data);
            if (this.request[key] === [])
              this.request.permitted = this.request.permitted.filter((e) => e != key);
          });
    },
    onAddContact() {
      const newContact = {
        data: this.contact.data,
        description: this.contact.description,
      };
      if (
        (this.contact.type && this.contact.type.name === "Phone") ||
        regexPhone.test(newContact.data) ||
        regexPhone2.test(newContact.data) ||
        newContact.data.includes("tel:")
      ) {
        if (this.request.phones_attributes)
          this.request.phones_attributes.push(newContact);
        else this.request["phones_attributes"] = [newContact];
        if (this.contact.type === null) newContact.type = "Phone";
      } else if (
        (this.contact.type && this.contact.type.name === "Email") ||
        regexMail.test(newContact.data)
      ) {
        if (this.request.emails_attributes)
          this.request.emails_attributes.push(newContact);
        else this.request["emails_attributes"] = [newContact];
        if (this.contact.type === null) newContact.type = "Email";
      } else if (this.contact.type && this.contact.type.name === "Fax") {
        if (this.request.faxes_attributes) this.request.faxes_attributes.push(newContact);
        else this.request["faxes_attributes"] = [newContact];
      }
      if (newContact.type === undefined && this.contact.type)
        newContact.type = this.contact.type.name
      this.pers.contacts.push(newContact);
      this.contact = { data: "", type: null, description: "" };
    },
    onNext(currentId, nextId) {
      document.getElementById(currentId).blur();
      document.getElementById(nextId).focus();
    },
    contactIcon(type) {
      return contactTypes.find(el => el.name===type).icon       
    },
    contactLinc(contact) {
      if (contact.data && contact.type) {
        if (contact.type==="Email") return "mailto:"+contact.data
        else if(contact.type==="Phone") return "tel:"+contact.data
      } else return false            
    },
    forceRerender() {      
      this.componentKey += 1;
      this.pers = this.$store.state.personDialog.person
      this.visible = this.$store.state.personDialog.visible
      this.request = { permitted: [] }
      this.contacts = []    
      if (this.pers.contacts) this.pers.contacts.forEach(contact =>{this.contacts.push(contact.data)})     
    },
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
</style>
