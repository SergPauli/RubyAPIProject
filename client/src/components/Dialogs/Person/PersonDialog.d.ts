interface Person {
    name?: string,
    middlename?: string,
    surname?: string,
    description?: string,
    contacts: Array
}

interface PersonDialogProps {
  visible: boolean,
  submitted: boolean,  
  person: Person  
}

declare class PersonDialog {
  $props: PersonDialogProps
}

export default PersonDialog
