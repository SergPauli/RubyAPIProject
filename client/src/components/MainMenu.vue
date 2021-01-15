<template>
  <Menu id="overlay_menu" ref="menu" :model="items" class="layout-menu-wrapper fadeInDown"  />
</template>

<script>
export default {
 name:"MainMenu",   
 data() {
        return {
            items: [
                {
                    label: "Items",
                    items: [{
                        label: "People",
                        icon: "pi pi-users",
                        to: "/Items/People"
                    },
                    {
                        label: 'Delete',
                        icon: 'pi pi-times',
                        command: () => {
                            this.$toast.add({ severity: 'warn', summary: 'Delete', detail: 'Data Deleted', life: 3000});
                        }
                    }
                ]},
                {
                    label: 'Navigate',
                    items: [{
                        label: 'Vue Website',
                        icon: 'pi pi-external-link',
                        url: 'https://vuejs.org/'
                    }
                ]}
            ]
        }
    },
    methods: {
        toggle(event) {
            this.$refs.menu.toggle(event);
        },
        save() {
            this.$toast.add({severity: 'success', summary: 'Success', detail: 'Data Saved', life: 3000});
        }
    }
}
</script>

<style>

</style>