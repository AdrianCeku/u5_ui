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

function getElementsHTML(identifier: string) {
  const elements = document.querySelectorAll(identifier)
  const elementsHTML = []

  for (let i = 0; i < elements.length; i++) {
    const element = elements[i]
    elementsHTML.push(element.outerHTML)
  }
 
  return elementsHTML
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
      :section="section"
      :section-id="sectionId"
      >
      <PolyComponent
        v-for="(component, componentId) in section.components"
        :key="componentId"
        :component="component"
        :sectionId="sectionId"
        :componentId="componentId"
      />
    </Section>
  </main>
</template>