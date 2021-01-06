<template>
  <ul class="layout-topbar-menu" >   
    <li class="layout-topbar-item">
      <a class="layout-topbar-icon first">
        <i class="topbar-icon pi pi-cog"></i>
      </a>
      <ul class="fadeInDown" >
        <li>
          <a href="#" class="layout-topbar-icon"
            ><i class="topbar-icon pi pi-bookmark"></i
          ></a>
          <div class="layout-quickmenu-tooltip">
            <div class="layout-quickmenu-tooltip-arrow"></div>
            <div class="layout-quickmenu-tooltip-text">Bookmarks</div>
          </div>
        </li>
        <li>
          <a href="#" class="layout-topbar-icon"
            ><i class="topbar-icon pi pi-chart-bar"></i
          ></a>
          <div class="layout-quickmenu-tooltip">
            <div class="layout-quickmenu-tooltip-arrow"></div>
            <div class="layout-quickmenu-tooltip-text">Statistics</div>
          </div>
        </li>
        <li>
          <a href="#" class="layout-topbar-icon"
            ><i class="topbar-icon pi pi-sign-out"></i
          ></a>
          <div class="layout-quickmenu-tooltip">
            <div class="layout-quickmenu-tooltip-arrow"></div>
            <div class="layout-quickmenu-tooltip-text">Sign Out</div>
          </div>
        </li>
      </ul>
    </li>
    <li class="layout-topbar-item">
      <a class="layout-topbar-icon first"><i class="topbar-icon pi pi-calendar"></i></a>
      <ul class="fadeInDown" style="display: none">
        <li><a href="#" class="layout-topbar-text"> SUN </a></li>
        <li><a href="#" class="layout-topbar-text"> MON </a></li>
        <li><a href="#" class="layout-topbar-text"> TUE </a></li>
      </ul>
    </li>    
  </ul>
</template>
<script>
import { defineComponent } from "vue"
import Ripple from "../ripple/Ripple"
import DomHandler from "../utils/DomHandler"
export default defineComponent({
    name: 'layout-topbar-menu',    
    emits: ['keydown-item', 'leaf-click'],
    props: {
        model: {
            type: Array,
            default: null
        },
        root: {
            type: Boolean,
            default: false
        },
        popup: {
            type: Boolean,
            default: false
        },
        parentActive: {
            type: Boolean,
            default: false
        },
        mobileActive: {
            type: Boolean,
            default: false
        }
    },
    documentClickListener: null,
    watch: {
        parentActive(newValue) {
            if (!newValue) {
                this.activeItem = null;
            }
        }
    },
    data() {
        return {
            activeItem: null
        }
    },
    updated() {
        if (this.root && this.activeItem) {
            this.bindDocumentClickListener();
        }
    },
    beforeUnmount() {
        this.unbindDocumentClickListener();
    },
    methods: {
        onItemMouseEnter(event, item) {
            if (item.disabled || this.mobileActive) {
                event.preventDefault();
                return;
            }
            if (this.root) {
                if (this.activeItem || this.popup) {
                    this.activeItem = item;
                }
            }
            else {
                this.activeItem = item;
            }
        },
        onItemClick(event, item, navigate) {
            if (item.disabled) {
                event.preventDefault();
                return;
            }
            if (item.command) {
                item.command({
                    originalEvent: event,
                    item: item
                });
            }
            if (item.items) {
                if (this.activeItem && item === this.activeItem)
                    this.activeItem = null;
                else
                   this.activeItem = item;
            }
            if (!item.items) {
                this.onLeafClick();
            }
            if (item.to && navigate) {
                navigate(event);
            }
        },
        onLeafClick() {
            this.activeItem = null;
            this.$emit('leaf-click');
        },
        onItemKeyDown(event, item) {
            let listItem = event.currentTarget.parentElement;
            switch(event.which) {
                //down
                case 40:
                    if (this.root) {
                        if (item.items) {
                            this.expandSubmenu(item, listItem);
                        }
                    }
                    else {
                        this.navigateToNextItem(listItem);
                    }
                    event.preventDefault();
                break;
                //up
                case 38:
                    if (!this.root) {
                        this.navigateToPrevItem(listItem);
                    }
                    event.preventDefault();
                break;
                //right
                case 39:
                    if (this.root) {
                        var nextItem = this.findNextItem(listItem);
                        if (nextItem) {
                            nextItem.children[0].focus();
                        }
                    }
                    else {
                        if (item.items) {
                            this.expandSubmenu(item, listItem);
                        }
                    }
                    event.preventDefault();
                break;
                //left
                case 37:
                    if (this.root) {
                        this.navigateToPrevItem(listItem);
                    }
                    event.preventDefault();
                break;
                default:
                break;
            }
            this.$emit('keydown-item', {
                originalEvent: event,
                element: listItem
            });
        },
        onChildItemKeyDown(event) {
            if (this.root) {
                //up
                if (event.originalEvent.which === 38 && event.element.previousElementSibling == null) {
                    this.collapseMenu(event.element);
                }
            }
            else {
                //left
                if (event.originalEvent.which === 37) {
                    this.collapseMenu(event.element);
                }
            }
        },
        findNextItem(item) {
            let nextItem = item.nextElementSibling;
            if (nextItem)
                return DomHandler.hasClass(nextItem, 'p-disabled') || !DomHandler.hasClass(nextItem, 'layout-topbar-item') ? this.findNextItem(nextItem) : nextItem;
            else
                return null;
        },
        findPrevItem(item) {
            let prevItem = item.previousElementSibling;
            if (prevItem)
                return DomHandler.hasClass(prevItem, 'p-disabled') || !DomHandler.hasClass(prevItem, 'layout-topbar-item') ? this.findPrevItem(prevItem) : prevItem;
            else
                return null;
        },
        expandSubmenu(item, listItem) {
            this.activeItem = item;
            setTimeout(() => {
                listItem.children[1].children[0].children[0].focus();
            }, 50);
        },
        collapseMenu(listItem) {
            this.activeItem = null;
            listItem.parentElement.previousElementSibling.focus();
        },
        navigateToNextItem(listItem) {
            var nextItem = this.findNextItem(listItem);
            if (nextItem) {
                nextItem.children[0].focus();
            }
        },
        navigateToPrevItem(listItem) {
            var prevItem = this.findPrevItem(listItem);
            if (prevItem) {
                prevItem.children[0].focus();
            }
        },
        getItemClass(item) {
            return ["layout-topbar-item", item.class, 
            {"active-topmenuitem": this.activeItem === item}]
        },
        
        getLinkClass(item, i) {
            return ['layout-topbar-icon', {'p-disabled': item.disabled},
            {"first": i === 0}];
        },
        bindDocumentClickListener() {
            if (!this.documentClickListener) {
                this.documentClickListener = (event) => {
                    if (this.$el && !this.$el.contains(event.target)) {
                        this.activeItem = null;
                        this.unbindDocumentClickListener();
                    }
                };
                document.addEventListener('click', this.documentClickListener);
            }
        },
        unbindDocumentClickListener() {
            if (this.documentClickListener) {
                document.removeEventListener('click', this.documentClickListener);
                this.documentClickListener = null;
            }
        },
        getSubmenuIcon() {
            return [
                'p-submenu-icon pi', {'pi-angle-right': !this.root, 'pi-angle-down': this.root}
            ];
        },
        visible(item) {
            return (typeof item.visible === 'function' ? item.visible() : item.visible !== false);
        }
    },
    computed: {
        containerClass() {
            return {'p-submenu-list': !this.root, 'p-menubar-root-list': this.root};
        }
    },
    directives: {
        'ripple': Ripple
    }
})
</script>