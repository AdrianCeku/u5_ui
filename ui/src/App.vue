<script setup lang="ts">
// IMPORTS
import { ref } from "vue";

import Section from "@/components/Section.vue"
import PolyComponent from "@/components/PolyComponent.vue"

// TYPES

export interface Component {    
    componentType: string
    style?: string
    innerHTML?: string
    onClickId?: number
    onInputId?: number
    isDeleted: boolean
    props?: {
      [key: string]: any
    }
  }

export interface Section {
  options: {
    title?: string
    image?: string
    showCloseButton?: boolean
    noDefaultStyle?: boolean
    noPresetStyle?: boolean
    noWrapperPositioningStyle?: boolean
    xAlign?: "left" | "center" | "right"
    yAlign?: "top" | "center" | "bottom"
    width?: "full" | "twoThirds" | "half" | "third" | "quarter" | "fit"
    height?: "full" | "twoThirds" | "half" | "third" | "quarter" | "fit"
    display?: "flex" | "grid" | "block"
    xOverflow?: "visible" | "hidden" | "scroll" | "auto"
    yOverflow?: "visible" | "hidden" | "scroll" | "auto"
  }
  isOpen?: boolean
  style?: string
  wrapperStyle?: string
  innerHTML?: string
  onVisibilityChangeFunctionId?: number
  isDeleted: boolean
  components: Component[]
}

interface Config {
  toggleKey: string
  toggleKeyJS: string
}

// VARIABLES
let config: Config

const sections = ref<Section[]>([])

const positioningStyleClasses = [
  "absolute", 
  "top-0", 
  "left-0", 
  "bottom-0", 
  "right-0",
]

const positioningClassesMap = {
  "xAlign": {
    "left": "mr-auto",
    "center": "mx-auto",
    "right": "ml-auto"
  },
  "yAlign": {
    "top": "mb-auto",
    "center": "my-auto",
    "bottom": "mt-auto"
  },
  "width": {
    "full": "w-full",
    "twoThirds": "w-2/3",
    "half": "w-1/2",
    "third": "w-1/3",
    "quarter": "w-1/4",
    "fit" : "w-fit"
  },
  "height": {
    "full": "h-full",
    "twoThirds": "h-2/3",
    "half": "h-1/2",
    "third": "h-1/3",
    "quarter": "h-1/4",
    "fit" : "h-fit"
  },

}
// HELPERS

function getPositioningClasses(sectionId: number) {
  const section = sections.value[sectionId]
  const options = section.options
  
  const classes = []

  if(!options.noWrapperPositioningStyle) {
    classes.push(positioningClassesMap.width[options.width ?? "fit"] ?? positioningClassesMap.width["fit"])
    classes.push(positioningClassesMap.height[options.height ?? "fit"] ?? positioningClassesMap.height["fit"])
    classes.push(positioningClassesMap.xAlign[options.xAlign ?? "center"] ?? positioningClassesMap.xAlign["center"])
    classes.push(positioningClassesMap.yAlign[options.yAlign ?? "center"] ?? positioningClassesMap.yAlign["center"])
    classes.push(...positioningStyleClasses)
  }

  return classes
}


function getCloseAnimation(sectionId: number) {
  const section = sections.value[sectionId]
  if(section.options.xAlign === "left") {
    return "slideLeft"
  }
  else if(section.options.xAlign === "right") {
    return "slideRight"
  }
  else if(section.options.yAlign === "top") {
    return "slideTop"
  }
  else if(section.options.yAlign === "bottom") {
    return "slideBottom"
  }

  return "slideTop"
}

function getOpenAnimation(sectionId: number) {
  const section = sections.value[sectionId]
  if(section.options.xAlign === "left") {
    return "slideLeftReverse"
  }
  else if(section.options.xAlign === "right") {
    return "slideRightReverse"
  }
  else if(section.options.yAlign === "top") {
    return "slideTopReverse"
  }
  else if(section.options.yAlign === "bottom") {
    return "slideBottomReverse"
  }

  return "slideTopReverse"
}

function getElementsHTML(identifier: string) {
  const elements = document.querySelectorAll(identifier)
  const elementsHTML = []

  for (let i = 0; i < elements.length; i++) {
    const element = elements[i]
    elementsHTML.push(element.outerHTML)
  }
 
  return elementsHTML
}

// TRIGGERS

function visibilityChanged(onVisibilityChangeFunctionId: number, isVisible: boolean, sectionId: number) {
  fetch(`https://u5_ui/visibilityChanged`, {
    method: "POST",
    headers: {
        "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({
        sectionId: sectionId,
        isVisible: isVisible,
        onVisibilityChangeFunctionId: onVisibilityChangeFunctionId
    })
  });
}

// SECTIONS

function addSection(section: Section) {
  section.components = []

  sections.value.push(section)
  const sectionId = sections.value.length - 1

  return sectionId
}

function updateSection(id: number, section: Section) {
  sections.value[id] = section
}

function openSection(sectionId: number) {
  const onVisChangeId = sections.value[sectionId].onVisibilityChangeFunctionId
  const section = document.getElementById(sectionId.toString())

  if(sections.value[sectionId].isOpen) return
  if(!section) return

  section.classList.remove(getCloseAnimation(sectionId))
  section.classList.add(getOpenAnimation(sectionId))

  if(onVisChangeId) {
    visibilityChanged(onVisChangeId, true, sectionId)
  }

  sections.value[sectionId].isOpen = true
}

function closeSection(sectionId: number) {
  const onVisChangeId = sections.value[sectionId].onVisibilityChangeFunctionId 
  const section = document.getElementById(sectionId.toString())

  if(!sections.value[sectionId].isOpen) return
  if(!section) return

  section.classList.remove(getOpenAnimation(sectionId))
  section.classList.add(getCloseAnimation(sectionId))
  
  if(onVisChangeId) {
    visibilityChanged(onVisChangeId, false, sectionId)
  }

  sections.value[sectionId].isOpen = false
}

function deleteSection(sectionId: number) {
  sections.value[sectionId].isDeleted = true
}

// COMPONENTS

function addComponent(sectionId: number, component: Section["components"][0]) {
  sections.value[sectionId].components.push(component)

  return sections.value[sectionId].components.length - 1
}

function updateComponent(sectionId: number, componentId: number, component: Section["components"][0]) {
  sections.value[sectionId].components[componentId] = component
}

function deleteComponent(sectionId: number, componentId: number) {
  sections.value[sectionId].components[componentId].isDeleted = true
}

function getComponentHTML(sectionId: number, componentId: number) {
  const id = sectionId.toString() + componentId.toString()
  const element = document.getElementById(id)?.outerHTML
  console.log(element)
  return element
}

// MESSAGE HANDLING

function handleCallback(data: any, callbackId: number) {
  let response = null

  if (data.type === "addSection") {
    response = addSection(data.section)
  }

  else if (data.type === "addComponent") {
    response = addComponent(data.sectionId, data.component)
  }

  else if (data.type === "getElementsHTML") {
    response = getElementsHTML(data.identifier)
  }

  else if (data.type === "getComponentElementHTML") {
    response = getComponentHTML(data.sectionId, data.componentId)
  }

  fetch(`https://u5_ui/uiCallback`, {
    method: "POST",
    headers: {
        "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({
        callbackId: callbackId,
        response: response
    })
  });
}

window.addEventListener("message", (event) => {
  if (event.data.type === "uiCallback") {
    const data = event.data
    handleCallback(data.payload, data.callbackId)
  }

  else if (event.data.type === "updateComponent") {
    const data = event.data.data
    updateComponent(data.sectionId, data.componentId, data.component)
  }

  else if (event.data.type === "updateSection") {
    const data = event.data.data
    updateSection(data.sectionId, data.section)
  }

  else if (event.data.type === "closeSection") {
    const data = event.data
    closeSection(data.sectionId)
  }

  else if (event.data.type === "openSection") {
    const data = event.data
    openSection(data.sectionId)
  }

  else if (event.data.type === "deleteSection") {
    deleteSection(event.data.sectionId)
  }

  else if (event.data.type === "deleteComponent") {
    deleteComponent(event.data.sectionId, event.data.componentId)
  }

  else if (event.data.type === "restoreSection") {
    sections.value[event.data.sectionId].isDeleted = false
  }

  else if (event.data.type === "restoreComponent") {
    sections.value[event.data.sectionId].components[event.data.componentId].isDeleted = false
  }
  	
  else if (event.data.type === "config") {
    config = event.data.config
    addExitListener()
  }
})

// EXIT

function exit() {
  fetch(`https://u5_ui/exit`, {
    method: "POST",
    headers: {
        "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({
        1: 1
    })
  });
}

function addExitListener() {
  window.addEventListener("keydown", (event) => {
    if (event.code.toLowerCase() === config.toggleKeyJS.toLowerCase()) {
      exit()
    }
  })
}

setTimeout(() => {
  if(!config) {
    console.warn("Timeout | No config received")
    console.log("Defaulting to Escape key")
    config = {
      toggleKey: "Escape",
      toggleKeyJS: "Escape",
    }
    addExitListener()
  }
}, 5000);

</script>

<template>
  <div class="p-10" v-if="false">
    <Accordion headline="Test" content="Wow"/>
    <Alert headline="Test" content="Wow"/>
    <AlertDialog trigger="amk" headline="Test" content="Wow" > <img src="https://forum.cfx.re/user_avatar/forum.cfx.re/sifro/288/3966684_2.png"/> </AlertDialog>
    <Input label="hello" type="email"/>
  </div>

  <main>
    <Section 
      v-for="(section, sectionId) in sections" 
      :key="sectionId" 
      :id="sectionId.toString()"
      :class="getPositioningClasses(sectionId)"
      class="m-10"
      :style="section.wrapperStyle"
      @event-close="closeSection(sectionId)"
      :section="section"
      >
      <div :v-if="section.innerHTML" v-html="section.innerHTML"></div>
      <PolyComponent
        v-for="(component, componentId) in section.components"
        :key="componentId"
        :id="sectionId.toString() + componentId.toString()"
        :component="component"
        :sectionId="sectionId"
        :componentId="componentId"
      />
    </Section>
  </main>
</template>

<style scoped>

  .slideTop {
    animation: slideTop 2.5s forwards;
  }

  .slideBottom {
    animation: slideBottom 2.5s forwards;
  }

  .slideLeft {
    animation: slideLeft 2.5s forwards;
  }

  .slideRight {
    animation: slideRight 2.5s forwards;
  }

  .slideTopReverse {
    animation: slideTopReverse 0.5s forwards;
  }

  .slideBottomReverse {
    animation: slideBottomReverse 0.5s forwards;
  }

  .slideLeftReverse {
    animation: slideLeftReverse 0.5s forwards;
  }

  .slideRightReverse {
    animation: slideRightReverse 0.5s forwards;
  }

  @keyframes slideTop {
    0% {
      transform: translateY(0);
      visibility: visible;
    }
    99% {
      visibility: hidden;
    }
    100% {
      transform: translateY(-100vh);
      visibility: hidden;
    }
  }

  @keyframes slideBottom {
    0% {
      transform: translateY(0);
      visibility: visible;
    }
    99% {
      visibility: hidden;
    }
    100% {
      transform: translateY(100vh);
      visibility: hidden;
    }
  }

  @keyframes slideLeft {
    0% {
      transform: translateX(0);
      visibility: visible;
    }
    99% {
      visibility: hidden;
    }
    100% {
      transform: translateX(-100vw);
      visibility: hidden;
    }
  }

  @keyframes slideRight {
    0% {
      transform: translateX(0);
      visibility: visible;
    }
    99% {
      visibility: hidden;
    }
    100% {
      transform: translateX(100vw);
      visibility: hidden;
    }
  }

  @keyframes slideTopReverse {
    0% {
      transform: translateY(-100vh);
      visibility: hidden;
    }
    1% {
      visibility: visible;
    }
    100% {
      transform: translateY(0);
      visibility: visible;
    }
  }

  @keyframes slideBottomReverse {
    0% {
      transform: translateY(100vh);
      visibility: hidden;
    }
    1% {
      visibility: visible;
    }
    100% {
      transform: translateY(0);
      visibility: visible;
    }
  }

  @keyframes slideLeftReverse {
    0% {
      transform: translateX(-100vw);
      visibility: hidden;
    }
    1% {
      visibility: visible;
    }
    100% {
      transform: translateX(0);
      visibility: visible;
    }
  }

  @keyframes slideRightReverse {
    0% {
      transform: translateX(100vw);
      visibility: hidden;
    }
    1% {
      visibility: visible;
    }
    100% {
      transform: translateX(0);
      visibility: visible;
    }
  }
</style>