<script setup lang="ts">
import { ref } from 'vue';

import { Button } from '@/components/ui/button'
import Accordion from '@/components/framework/Accordion.vue'

interface ComponentMap {
  [key: string]: any;
}
const componentMap: ComponentMap = {
  "Button": Button,
  "Accordion": Accordion
}

function getComponent(componentType: string) {
  return componentMap[componentType]
}


interface Section {
  options: {
    title?: string
    image?: string
    xAlign?: "left" | "center" | "right"
    yAlign?: "top" | "center" | "bottom"
    width?: "full" | "twoThirds" | "half" | "third" | "quarter"
    height?: "full" | "twoThirds" | "half" | "third" | "quarter"
    display?: "flex" | "grid" | "block" | "hidden"
    xOverflow?: "visible" | "hidden" | "scroll" | "auto"
    yOverflow?: "visible" | "hidden" | "scroll" | "auto"
    style?: string[]
  }
  components: {    
    componentType: string
    props?: {
      [key: string]: any
    }
    onClickId?: number
    style?: string[]
    }[]
}

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
    "quarter": "w-1/4"
  },
  "height": {
    "full": "h-full",
    "twoThirds": "h-2/3",
    "half": "h-1/2",
    "third": "h-1/3",
    "quarter": "h-1/4"
  },
  "display": {
    "flex": "flex",
    "grid": "grid",
    "block": "block",
    "hidden": "hidden"
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

function getClasses(sectionOptions: Section['options']) {
  const classes = []

  classes.push(classesMap.xAlign[sectionOptions.xAlign ?? "center"])
  classes.push(classesMap.yAlign[sectionOptions.yAlign ?? "center"])
  classes.push(classesMap.width[sectionOptions.width ?? "full"])
  classes.push(classesMap.height[sectionOptions.height ?? "full"])
  classes.push(classesMap.display[sectionOptions.display ?? "block"])
  classes.push(classesMap.xOverflow[sectionOptions.xOverflow ?? "auto"])
  classes.push(classesMap.yOverflow[sectionOptions.yOverflow ?? "auto"])

  return classes
}

function closeSection(sectionId: number) {
  const section = document.getElementById(sectionId.toString())
  if(section) {
    section.style.display = "none"
  }
}

function openSection(sectionId: number) {
  const section = document.getElementById(sectionId.toString())
  if(section) {
    section.style.display = sections.value[sectionId].options.display ?? "block"
  }
}


window.addEventListener('message', (event) => {
  if (event.data.type === 'addSection') {
    const section = {
      options: event.data.options,
      components: []
    }
    sections.value.push(section)
    
    fetch(`https://u5_ui/sendSectionId`, {
      method: 'POST',
      headers: {
          'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({
          id: sections.value.length - 1
      })
    });
  }

  else if (event.data.type === 'updateSection') {
    sections.value[event.data.id].options = event.data.options
  }

  else if (event.data.type === "addComponent") {
    console.log("addComponent")
    console.log(event.data)
    sections.value[event.data.sectionId].components.push(event.data.component)
    console.log(sections.value[event.data.sectionId].components)

    fetch(`https://u5_ui/sendComponentId`, {
      method: 'POST',
      headers: {
          'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({
          id: sections.value[event.data.sectionId].components.length - 1
      })
    });
  }

  else if (event.data.type === "updateComponent") {
    sections.value[event.data.sectionId].components[event.data.componentId] = event.data.component
  }

})

function clickTriggered(id: number) {
  fetch(`https://u5_ui/clickTriggered`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        id: id
    })
  });
}

</script>

<template>
  <main class="p-10 h-svh w-svw">
    <section 
      v-for="(section, sectionId) in sections" 
      :key="sectionId" 
      :id="sectionId.toString()"
      :class="getClasses(section.options)"
      :style='section.options.style'
      class="absolute top-0 left-0 bottom-0 right-0 bg-background rounded-md rounded-t-2xl rounded-r-2xl"
    >
    <header class="h-20 flex justify-between p-2 items-center">
      <img 
        :v-if="section.options.image"
        :src="section.options.image"
        class="h-full"
      >
      <h1 
        :v-if="section.options.title"
        class="text-xl font-bold text-center"
      >
        {{ section.options.title }}
      </h1>
      <svg
        class="h-1/2 cursor-pointer"  
        xmlns="http://www.w3.org/2000/svg" 
        viewBox="0 0 512 512"
        @click="closeSection(sectionId)"
      >
        <path 
          fill="currentColor"
          d="M256 48a208 208 0 1 1 0 416 208 208 0 1 1 0-416zm0 464A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM175 175c-9.4 9.4-9.4 24.6 0 33.9l47 47-47 47c-9.4 9.4-9.4 24.6 0 33.9s24.6 9.4 33.9 0l47-47 47 47c9.4 9.4 24.6 9.4 33.9 0s9.4-24.6 0-33.9l-47-47 47-47c9.4-9.4 9.4-24.6 0-33.9s-24.6-9.4-33.9 0l-47 47-47-47c-9.4-9.4-24.6-9.4-33.9 0z"
          />
      </svg>
    </header>
      <component
        v-for="(component, componentId) in section.components"
        :key="componentId"
        :component-id="componentId"
        :is="getComponent(component.componentType)"
        v-bind="component.props"
        :style='component.style'
        @click="component.onClickId ? clickTriggered(component.onClickId) : null"
      >
      </component>
    </section>
  </main>
</template>