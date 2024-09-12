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
    showCloseButton?: boolean
    xAlign?: "left" | "center" | "right"
    yAlign?: "top" | "center" | "bottom"
    width?: "full" | "twoThirds" | "half" | "third" | "quarter" | "fit"
    height?: "full" | "twoThirds" | "half" | "third" | "quarter" | "fit"
    display?: "flex" | "grid" | "block"
    xOverflow?: "visible" | "hidden" | "scroll" | "auto"
    yOverflow?: "visible" | "hidden" | "scroll" | "auto"
  }
  onCloseId?: number
  style?: string
  innerHTML?: string
  components: {    
    componentType: string
    props?: {
      [key: string]: any
    }
    innerHTML?: string
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

function getClasses(sectionOptions: Section['options']) {
  const classes = []

  classes.push(classesMap.xAlign[sectionOptions.xAlign ?? "center"])
  classes.push(classesMap.yAlign[sectionOptions.yAlign ?? "center"])
  classes.push(classesMap.width[sectionOptions.width ?? "fit"])
  classes.push(classesMap.height[sectionOptions.height ?? "fit"])
  classes.push(classesMap.display[sectionOptions.display ?? "block"])
  classes.push(classesMap.xOverflow[sectionOptions.xOverflow ?? "auto"])
  classes.push(classesMap.yOverflow[sectionOptions.yOverflow ?? "auto"])

  return classes
}

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

function closeSection(sectionId: number, onCloseId: number | undefined) {
  const section = document.getElementById(sectionId.toString())
  if(section) {
    section.classList.add(getCloseAnimation(sectionId))
  }
  if(onCloseId) {
    clickTriggered(onCloseId)
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
      onCloseId: event.data.onCloseId,
      style: event.data.style,
      innerHTML: event.data.innerHTML,
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

window.addEventListener("keyup", (event) => {
  if (event.key.toLowerCase() === "e") {
    exit()
  }
})

</script>

<template>
  <main class="h-svh w-svw">
    <section 
      v-for="(section, sectionId) in sections" 
      :key="sectionId" 
      :id="sectionId.toString()"
      :class="getClasses(section.options)"
      :style='section.style'
      class="absolute m-10 px-5 pb-5 pt-2 top-0 left-0 bottom-0 right-0 bg-background rounded-md rounded-t-2xl shadow-lg"
    >
    <header class="grid">
      <svg
        v-if="!section.options.showCloseButton === false"
        class="h-6 ml-auto cursor-pointer hover:scale-105 transition-transform translate-x-3"  
        xmlns="http://www.w3.org/2000/svg" 
        viewBox="0 0 512 512"
        @click="closeSection(sectionId, section.onCloseId)"
      >
        <path 
          fill="currentColor"
          d="M256 48a208 208 0 1 1 0 416 208 208 0 1 1 0-416zm0 464A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM175 175c-9.4 9.4-9.4 24.6 0 33.9l47 47-47 47c-9.4 9.4-9.4 24.6 0 33.9s24.6 9.4 33.9 0l47-47 47 47c9.4 9.4 24.6 9.4 33.9 0s9.4-24.6 0-33.9l-47-47 47-47c9.4-9.4 9.4-24.6 0-33.9s-24.6-9.4-33.9 0l-47 47-47-47c-9.4-9.4-24.6-9.4-33.9 0z"
          />
      </svg>
      <div 
        :v-if="section.options.image || section.options.title"
        class="flex items-center gap-5 justify-between"
      >
        <img 
          :v-if="section.options.image"
          :src="section.options.image"
          class="h-7"
        >
        <h1 
          :v-if="section.options.title"
          class="text-xl font-bold text-center"
        >
          {{ section.options.title }}
        </h1>
      </div>
    </header>
      <div :v-if="section.innerHTML" v-html="section.innerHTML"></div>
      <component
        v-for="(component, componentId) in section.components"
        :key="componentId"
        :component-id="componentId"
        :is="getComponent(component.componentType)"
        v-bind="component.props"
        :style='component.style'
        @click="component.onClickId ? clickTriggered(component.onClickId) : null"
      >
        <div :v-if="component.innerHTML" v-html="component.innerHTML"></div>
      </component>
    </section>
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

  @keyframes slideTop {
    0% {
      transform: translateY(0);
    }
    99% {
      transform: translateY(-100vh);
    }
    100% {
      transform: translateY(-100vh);
      visibility: hidden;
    }
  }

  @keyframes slideBottom {
    0% {
      transform: translateY(0);
    }
    99% {
      transform: translateY(100vh);
    }
    100% {
      transform: translateY(100vh);
      visibility: hidden;
    }
  }

  @keyframes slideLeft {
    0% {
      transform: translateX(0);
    }
    99% {
      transform: translateX(-100vw);
    }
    100% {
      transform: translateX(-100vw);
      visibility: hidden;
    }
  }

  @keyframes slideRight {
    0% {
      transform: translateX(0);
    }
    99% {
      transform: translateX(100vw);
    }
    100% {
      transform: translateX(100vw);
      visibility: hidden;
    }
  }
</style>