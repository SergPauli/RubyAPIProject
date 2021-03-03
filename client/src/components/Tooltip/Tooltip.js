import { uniqueComponentId } from "@/utils/uniqueComponentId"
import  ConnectedOverlayScrollHandler  from "@/utils/ConnectedOverlayScrollHandler"
import DomHandler from "@/utils/DomHandler" 

function unbindScrollListener(el) {
  if (el.$_ptooltipScrollHandler) {
    el.$_ptooltipScrollHandler.unbindScrollListener()
  }
}



function create(el) {
  const id = uniqueComponentId() + "_tooltip"
  el['$_ptooltipId'] = id

  const container = document.createElement("div")
  container.id = id

  const tooltipArrow = document.createElement("div")
  tooltipArrow.className = "p-tooltip-arrow"
  container.appendChild(tooltipArrow)

  const tooltipText = document.createElement("div")
  tooltipText.className = "p-tooltip-text"
  tooltipText.innerHTML = el.$_ptooltipValue

  container.appendChild(tooltipText)  
  document.body.appendChild(container)

  container.style.display = "inline-block"  
  return container
}

function getTooltipElement(el) {
  return document.getElementById(el.$_ptooltipId)
}

function preAlign(el, position) {
  const tooltipElement = getTooltipElement(el)
  tooltipElement.style.left = -999 + "px"
  tooltipElement.style.top = -999 + "px"
  tooltipElement.className = "p-tooltip p-component p-tooltip-" + position
}

function getHostOffset(el) {
  const offset = el.getBoundingClientRect()
  const targetLeft = offset.left + DomHandler.getWindowScrollLeft()
  const targetTop = offset.top + DomHandler.getWindowScrollTop()

  return { left: targetLeft, top: targetTop }
}

function alignRight(el) {
  preAlign(el, "right")
  const tooltipElement = getTooltipElement(el)
  const hostOffset = getHostOffset(el)
  const left = hostOffset.left + DomHandler.getOuterWidth(el)
  const top = hostOffset.top + (DomHandler.getOuterHeight(el) - DomHandler.getOuterHeight(tooltipElement)) / 2
  tooltipElement.style.left = left + "px"
  tooltipElement.style.top = top + "px"
}

function alignLeft(el) {
  preAlign(el, "left")
  const tooltipElement = getTooltipElement(el)
  const hostOffset = getHostOffset(el)
  const left = hostOffset.left - DomHandler.getOuterWidth(tooltipElement)
  const top = hostOffset.top + (DomHandler.getOuterHeight(el) - DomHandler.getOuterHeight(tooltipElement)) / 2
  tooltipElement.style.left = left + "px"
  tooltipElement.style.top = top + "px"
}

function alignTop(el) {
  preAlign(el, "top")
  const tooltipElement = getTooltipElement(el)
  const hostOffset = getHostOffset(el)  
  const left = hostOffset.left + (DomHandler.getOuterWidth(el) - DomHandler.getOuterWidth(tooltipElement)) / 2
  const top = hostOffset.top - DomHandler.getOuterHeight(tooltipElement)
  tooltipElement.style.left = left + "px"
  tooltipElement.style.top = top + "px"
}

function alignBottom(el) {
  preAlign(el, "bottom")
  const tooltipElement = getTooltipElement(el)
  const hostOffset = getHostOffset(el)
  const left = hostOffset.left + (DomHandler.getOuterWidth(el) - DomHandler.getOuterWidth(tooltipElement)) / 2
  const top = hostOffset.top + DomHandler.getOuterHeight(el)
  tooltipElement.style.left = left + "px"
  tooltipElement.style.top = top + "px"
}

function isOutOfBounds(el) {
  const tooltipElement = getTooltipElement(el)
  const offset = tooltipElement.getBoundingClientRect()
  const targetTop = offset.top
  const targetLeft = offset.left
  const width = DomHandler.getOuterWidth(tooltipElement)
  const height = DomHandler.getOuterHeight(tooltipElement)
  const viewport = DomHandler.getViewport()

  return targetLeft + width > viewport.width || targetLeft < 0 || targetTop < 0 || targetTop + height > viewport.height
}
function align(el) {
  const modifiers = el.$_ptooltipModifiers

  if (modifiers.top) {
    alignTop(el)
    if (isOutOfBounds(el)) {
      alignBottom(el)
    }
  } else if (modifiers.left) {
    alignLeft(el)
    if (isOutOfBounds(el)) {
      alignRight(el)

      if (isOutOfBounds(el)) {
        alignTop(el)

        if (isOutOfBounds(el)) {
          alignBottom(el)
        }
      }
    }
  } else if (modifiers.bottom) {
    alignBottom(el)
    if (isOutOfBounds(el)) {
      alignTop(el)
    }
  } else {
    alignRight(el)
    if (isOutOfBounds(el)) {
      alignLeft(el)

      if (isOutOfBounds(el)) {
        alignTop(el)

        if (isOutOfBounds(el)) {
          alignBottom(el)
        }
      }
    }
  }
}

function remove(el) {
  if (el) {
    const tooltipElement = getTooltipElement(el)
    if (tooltipElement && tooltipElement.parentElement) {
      document.body.removeChild(tooltipElement)
    }
    el["$_ptooltipId"] = null
  }
}

function hide(el) {
  remove(el)
  unbindScrollListener(el)
}

function bindScrollListener(el) {
  if (!el["$_ptooltipScrollHandler"]) {
    el["$_ptooltipScrollHandler"] = new ConnectedOverlayScrollHandler(el, function() {
      hide(el)
    })
  }

  el.$_ptooltipScrollHandler.bindScrollListener()
}

function show(el) {
  if (!el.$_ptooltipValue) {
    return
  }

  const tooltipElement = create(el)  
  align(el)  
  DomHandler.fadeIn(tooltipElement, 250)
  tooltipElement.style.zIndex = DomHandler.generateZIndex()
  window.addEventListener("resize", function onWindowResize() {
    hide(el)
    this.removeEventListener("resize", onWindowResize)
  })  
  bindScrollListener(el)  
}



function onMouseEnter(event) {
  show(event.currentTarget)
}

function onMouseLeave(event) {
  hide(event.currentTarget)
}

function onFocus(event) {
  show(event.currentTarget)
}

function onBlur(event) {
  hide(event.currentTarget)
}

function onClick(event) {
  hide(event.currentTarget)
}

function bindEvents(el) {
  const modifiers = el.$_ptooltipModifiers
  if (modifiers.focus) {
    el.addEventListener("focus", onFocus)
    el.addEventListener("blur", onBlur)
  } else {
    el.addEventListener("mouseenter", onMouseEnter)
    el.addEventListener("mouseleave", onMouseLeave)
    el.addEventListener("click", onClick)
  }
}

function unbindEvents(el) {
  const modifiers = el.$_ptooltipModifiers
  if (modifiers.focus) {
    el.removeEventListener("focus", onFocus)
    el.removeEventListener("blur", onBlur)
  } else {
    el.removeEventListener("mouseenter", onMouseEnter)
    el.removeEventListener("mouseleave", onMouseLeave)
    el.removeEventListener("click", onClick)
  }
}

function getTarget(el) {
  return DomHandler.hasClass(el, "p-inputwrapper") ? DomHandler.findSingle(el, "input") : el
}

const Tooltip = {
  beforeMount(el, options) {
    const target = getTarget(el)
    target['$_ptooltipModifiers'] = options.modifiers
    target['$_ptooltipValue'] = options.value
    bindEvents(target)
  },
  unmounted(el) {
    const target = getTarget(el)
    remove(target)
    unbindEvents(target)

    if (target.$_ptooltipScrollHandler) {
      target.$_ptooltipScrollHandler.destroy()
      target['$_ptooltipScrollHandler'] = null
    }
  },
  updated(el, options) {
    const target = getTarget(el)
    target['$_ptooltipModifiers'] = options.modifiers
    target['$_ptooltipValue'] = options.value
  },
}
export default Tooltip