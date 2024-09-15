<script setup lang="ts">
// IMPORTS
import { ref } from 'vue';

import SectionU5 from '@/components/u5/SectionU5.vue'
import ComponentU5 from '@/components/u5/ComponentU5.vue'

// TYPES

interface Section {
  isDeleted: boolean
  isOpen: boolean
  options: {
    title?: string
    image?: string
    showCloseButton?: boolean
    xAlign?: "left" | "center" | "right"
    yAlign?: "top" | "center" | "bottom"
    width?: "full" | "twoThirds" | "half" | "third" | "quarter" | "fit"
    height?: "full" | "twoThirds" | "half" | "third" | "quarter" | "fit"
    display?: "flex" | "grid" | "block"
    xOverflow?: "visible" | "hidden" | "scroll" | "auto"
    yOverflow?: "visible" | "hidden" | "scroll" | "auto"
  }
  style?: string
  innerHTML?: string
  onOpenId?: number
  onCloseId?: number
  components: {    
    isDeleted: boolean
    componentType: string
    props?: {
      [key: string]: any
    }
    innerHTML?: string
    onClickId?: number
    onInputId?: number
    style?: string[]
  }[]
}

// VARIABLES

const sections = ref<Section[]>([])

const classesMap = {
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
  "display": {
    "flex": "flex",
    "grid": "grid",
    "block": "block"
  },
  "xOverflow": {
    "visible": "overflow-x-visible",
    "hidden": "overflow-x-hidden",
    "scroll": "overflow-x-scroll",
    "auto": "overflow-x-auto"
  },
  "yOverflow": {
    "visible": "overflow-y-visible",
    "hidden": "overflow-y-hidden",
    "scroll": "overflow-y-scroll",
    "auto": "overflow-y-auto"
  }
}

// HELPERS

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

function getClasses(sectionId: number) {
  const classes = []
  const section = sections.value[sectionId]
  const options = section.options

  classes.push(classesMap.xAlign[options.xAlign ?? "center"] ?? classesMap.xAlign["center"])
  classes.push(classesMap.yAlign[options.yAlign ?? "center"] ?? classesMap.yAlign["center"])
  classes.push(classesMap.width[options.width ?? "fit"] ?? classesMap.width["fit"])
  classes.push(classesMap.height[options.height ?? "fit"] ?? classesMap.height["fit"])
  classes.push(classesMap.display[options.display ?? "block"] ?? classesMap.display["block"])
  classes.push(classesMap.xOverflow[options.xOverflow ?? "auto"] ?? classesMap.xOverflow["auto"])
  classes.push(classesMap.yOverflow[options.yOverflow ?? "auto"] ?? classesMap.yOverflow["auto"])

  return classes
}

function getElement(identifier: string) {
  const elements = document.querySelectorAll(identifier)
  const elementsHTML = []

  for (let i = 0; i < elements.length; i++) {
    const element = elements[i]
    elementsHTML.push(element.outerHTML)
  }
 
  return elementsHTML
}

// TRIGGERS

function clickTriggered(id: number, passThrough: any, sectionId: number, componentId: number) {
  console.log("clickTriggered", id, passThrough, sectionId, componentId)
  fetch(`https://u5_ui/clickTriggered`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        id: id,
        passThrough: passThrough,
        sectionId: sectionId,
        componentId: componentId
    })
  });
}

function changeTriggered(id: number, value: any, sectionId: number, componentId: number) {
  console.log("changeTriggered", id, value, sectionId, componentId)
  fetch(`https://u5_ui/changeTriggered`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        id: id,
        value: value,
        sectionId: sectionId,
        componentId: componentId
    })
  });
}

// SECTIONS

function addSection(section: Section) {
  section.components = []

  sections.value.push(section)

  return sections.value.length - 1
}

function updateSection(id: number, section: Section) {
  sections.value[id] = section
}

function openSection(sectionId: number) {
  const onOpenId = sections.value[sectionId].onOpenId
  const section = document.getElementById(sectionId.toString())

  if(section) {
    section.classList.remove(getCloseAnimation(sectionId))
    section.classList.add(getOpenAnimation(sectionId))
  }

  if(onOpenId) {
    clickTriggered(onOpenId, null, sectionId, -1)
  }

  sections.value[sectionId].isOpen = true
}

function closeSection(sectionId: number) {
  const onCloseId = sections.value[sectionId].onCloseId
  const section = document.getElementById(sectionId.toString())

  if(section) {
    section.classList.remove(getOpenAnimation(sectionId))
    section.classList.add(getCloseAnimation(sectionId))
  }
  if(onCloseId) {
    clickTriggered(onCloseId, null, sectionId, -1)
  }

  sections.value[sectionId].isOpen = false
}

function deleteSection(sectionId: number) {
  sections.value[sectionId].isDeleted = true
}

// COMPONENTS

function addComponent(sectionId: number, component: Section['components'][0]) {
  sections.value[sectionId].components.push(component)

  return sections.value[sectionId].components.length - 1
}

function updateComponent(sectionId: number, componentId: number, component: Section['components'][0]) {
  sections.value[sectionId].components[componentId] = component
}

function deleteComponent(sectionId: number, componentId: number) {
  sections.value[sectionId].components[componentId].isDeleted = true
}

function getComponent(sectionId: number, componentId: number) {
  const id = sectionId.toString() + componentId.toString()
  const element = document.getElementById(id)?.outerHTML

  return element
}

// MESSAGE HANDLING

function handleCallback(data: any, callbackId: number) {
  let response = null

  if (data.type === 'addSection') {
    response = addSection(data.section)
  }

  else if (data.type === "addComponent") {
    response = addComponent(data.sectionId, data.component)
  }

  else if (data.type === "getElement") {
    response = getElement(data.identifier)
  }

  else if (data.type === "getComponentElement") {
    response = getComponent(data.sectionId, data.componentId)
  }

  fetch(`https://u5_ui/uiCallback`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        callbackId: callbackId,
        response: response
    })
  });

}

window.addEventListener('message', (event) => {
  if (event.data.type === 'uiCallback') {
    const data = event.data
    handleCallback(data.payload, data.callbackId)
  }

  else if (event.data.type === "updateComponent") {
    const data = event.data.data
    updateComponent(data.sectionId, data.componentId, data.component)
  }

  else if (event.data.type === 'updateSection') {
    const data = event.data.data
    updateSection(data.sectionId, data.section)
  }

  else if (event.data.type === 'closeSection') {
    const data = event.data
    closeSection(data.sectionId)
  }

  else if (event.data.type === 'openSection') {
    const data = event.data
    openSection(data.sectionId)
  }

  else if (event.data.type === 'deleteSection') {
    deleteSection(event.data.sectionId)
  }

  else if (event.data.type === 'deleteComponent') {
    deleteComponent(event.data.sectionId, event.data.componentId)
  }

  else if (event.data.type === 'restoreSection') {
    sections.value[event.data.sectionId].isDeleted = false
  }

  else if (event.data.type === 'restoreComponent') {
    sections.value[event.data.sectionId].components[event.data.componentId].isDeleted = false
  }

})

// EXIT

function exit() {
  fetch(`https://u5_ui/exit`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        1: 1
    })
  });
}

window.addEventListener("keydown", (event) => {
  if (event.key.toLowerCase() === "alt") {
    exit()
  }
})

</script>

<template>
  <div class="p-10" v-if="false">
    <Accordion headline="Test" content="Wow"/>
    <Alert headline="Test" content="Wow"/>
    <AlertDialog trigger="amk" headline="Test" content="Wow" > <img src="https://forum.cfx.re/user_avatar/forum.cfx.re/sifro/288/3966684_2.png"/> </AlertDialog>
    <Input label="hello" type="email"/>
  </div>

  <main class="h-svh w-svw">
    <SectionU5 
      v-for="(section, sectionId) in sections" 
      :key="sectionId" 
      :id="sectionId.toString()"
      :class="getClasses(sectionId)"
      :style='section.style'
      class="absolute top-0 left-0 bottom-0 right-0"
      @event-close="closeSection(sectionId)"
      :section="section"
      >
      <div :v-if="section.innerHTML" v-html="section.innerHTML"></div>
      <ComponentU5
        v-for="(component, componentId) in section.components"
        :key="componentId"
        :id="sectionId.toString() + componentId.toString()"
        :component="component"
        :style="component.style"
        @event-click="(passThrough: any) => component.onClickId && clickTriggered(component.onClickId, passThrough, sectionId, componentId)"
        @event-input="(value: any) => component.onInputId && changeTriggered(component.onInputId, value, sectionId, componentId)"
      />
    </SectionU5>
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
    }
    100% {
      transform: translateY(-100vh);
    }
  }

  @keyframes slideBottom {
    0% {
      transform: translateY(0);
    }
    100% {
      transform: translateY(100vh);
    }
  }

  @keyframes slideLeft {
    0% {
      transform: translateX(0);
    }
    100% {
      transform: translateX(-100vw);
    }
  }

  @keyframes slideRight {
    0% {
      transform: translateX(0);
    }

    100% {
      transform: translateX(100vw);
    }
  }

  @keyframes slideTopReverse {
    0% {
      transform: translateY(-100vh);
    }
    100% {
      transform: translateY(0);
    }
  }

  @keyframes slideBottomReverse {
    0% {
      transform: translateY(100vh);
    }
    100% {
      transform: translateY(0);
    }
  }

  @keyframes slideLeftReverse {
    0% {
      transform: translateX(-100vw);
    }
    100% {
      transform: translateX(0);
    }
  }

  @keyframes slideRightReverse {
    0% {
      transform: translateX(100vw);
    }
    100% {
      transform: translateX(0);
    }
  }
</style>