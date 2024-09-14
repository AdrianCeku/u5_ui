<script setup lang="ts">
import { ref } from 'vue';

import Accordion from '@/components/u5/Accordion.vue'
import Alert from '@/components/u5/Alert.vue'
import AlertDialog from '@/components/u5/AlertDialog.vue'
import Input from '@/components/u5/Input.vue'
import SectionU5 from '@/components/u5/SectionU5.vue'

interface ComponentMap {
  [key: string]: any;
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
    onInputId?: number
    style?: string[]
  }[]
}
const sections = ref<Section[]>([])

const componentMap: ComponentMap = {
  "Accordion": Accordion,
  "Alert": Alert,
  "AlertDialog": AlertDialog,
  "Input": Input,
}

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

function getComponent(componentType: string) {
  return componentMap[componentType]
}

function getClasses(sectionOptions: Section['options']) {
  const classes = []

  classes.push(classesMap.xAlign[sectionOptions.xAlign ?? "center"] ?? classesMap.xAlign["center"])
  classes.push(classesMap.yAlign[sectionOptions.yAlign ?? "center"] ?? classesMap.yAlign["center"])
  classes.push(classesMap.width[sectionOptions.width ?? "fit"] ?? classesMap.width["fit"])
  classes.push(classesMap.height[sectionOptions.height ?? "fit"] ?? classesMap.height["fit"])
  classes.push(classesMap.display[sectionOptions.display ?? "block"] ?? classesMap.display["block"])
  classes.push(classesMap.xOverflow[sectionOptions.xOverflow ?? "auto"] ?? classesMap.xOverflow["auto"])
  classes.push(classesMap.yOverflow[sectionOptions.yOverflow ?? "auto"] ?? classesMap.yOverflow["auto"])

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

function sendElement(identifier: string) {
  console.log("sendElement", identifier)
  const element = document.querySelectorAll(identifier)
  console.log(element)
  fetch(`https://u5_ui/sendElement`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        element: element
    })
  });
}

function sendComponentElement(sectionId: number, componentId: number) {
  console.log("sendComponentElement", sectionId, componentId)
  const id = sectionId.toString() + componentId.toString()
  console.log(id)
  const element = document.getElementById(id)
  console.log(element)
  fetch(`https://u5_ui/sendElement`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        element: element
    })
  });
}

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

function addSection(options: Section['options'], onCloseId: number | undefined, style: string, innerHTML: string) {
  const section = {
      options: options,
      onCloseId: onCloseId,
      style: style,
      innerHTML: innerHTML,
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

function updateSection(id: number, options: Section['options']) {
  sections.value[id].options = options
}

function closeSection(sectionId: number, onCloseId: number | undefined) {
  const section = document.getElementById(sectionId.toString())
  if(section) {
    section.classList.add(getCloseAnimation(sectionId))
  }
  if(onCloseId) {
    clickTriggered(onCloseId, null, sectionId, -1)
  }
}

function openSection(sectionId: number) {
  const section = document.getElementById(sectionId.toString())
  if(section) {
    section.classList.remove(getCloseAnimation(sectionId))
  }
}

function addComponent(sectionId: number, component: Section['components'][0]) {
  sections.value[sectionId].components.push(component)

  fetch(`https://u5_ui/sendComponentId`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        id: sections.value[sectionId].components.length - 1
    })
  });
}

function updateComponent(sectionId: number, componentId: number, component: Section['components'][0]) {
  sections.value[sectionId].components[componentId] = component
}


window.addEventListener('message', (event) => {
  if (event.data.type === 'addSection') {
    addSection(event.data.options, event.data.onCloseId, event.data.style, event.data.innerHTML)
  }

  else if (event.data.type === 'updateSection') {
    updateSection(event.data.id, event.data.options)
  }

  else if (event.data.type === 'closeSection') {
    closeSection(event.data.id, event.data.onCloseId)
  }

  else if (event.data.type === 'openSection') {
    openSection(event.data.id)
  }

  else if (event.data.type === "addComponent") {
    addComponent(event.data.sectionId, event.data.component)
  }

  else if (event.data.type === "updateComponent") {
    updateComponent(event.data.sectionId, event.data.componentId, event.data.component)
  }

  else if (event.data.type === "getElement") {
    sendElement(event.data.identifier)
  }

  else if (event.data.type === "getComponentElement") {
    sendComponentElement(event.data.sectionId, event.data.componentId)
  }

})

window.addEventListener("keydown", (event) => {
  if (event.key.toLowerCase() === "alt") {
    exit()
  }
})

</script>

<template>
  <div class="p-10">
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
      :class="getClasses(section.options)"
      :style='section.style'
      class="absolute top-0 left-0 bottom-0 right-0"
      @event-close="closeSection(sectionId, section.onCloseId)"
      :section="section"
    >
      <div :v-if="section.innerHTML" v-html="section.innerHTML"></div>
      <component
        v-for="(component, componentId) in section.components"
        :key="componentId"
        :id="sectionId.toString() + componentId.toString()"
        :is="getComponent(component.componentType)"
        v-bind="component.props"
        :style="component.style"
        @event-click="(passThrough: any) => component.onClickId && clickTriggered(component.onClickId, passThrough, sectionId, componentId)"
        @event-input="(value: any) => component.onInputId && changeTriggered(component.onInputId, value, sectionId, componentId)"
        >
        <div :v-if="component.innerHTML" v-html="component.innerHTML"></div>
      </component>
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