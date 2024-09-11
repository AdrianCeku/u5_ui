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

interface Section {
  options: {
    title: string
    xAlign: "left" | "center" | "right"
    yAlign: "top" | "center" | "bottom"
    width: "full" | "half" | "third" | "quarter"
    height: "full" | "half" | "third" | "quarter"
    display: "flex" | "grid" | "block" | "hidden"
    classes: string[]
  }
  components: [
    {    
      type: string
      props: {
        [key: string]: any
      }
      onClickId: number
    }
  ]
}

const sections = ref<Section[]>([])


window.addEventListener('message', (event) => {
  if (event.data.type === 'addSection') {
    sections.value.push(event.data.section)
    
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
    sections.value[event.data.id] = event.data.section
  }

  else if (event.data.type === "addComponentToSection") {
    sections.value[event.data.sectionId].components.push(event.data.component)

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
  <div>
    <div 
      v-for="(section, sectionId) in sections" 
      :key="sectionId" 
      :class="[section.options.classes]"
    >
      <h1 :v-if="section.options.title">{{ section.options.title }}</h1>
      <component
        v-for="(component, componentId) in section.components"
        :key="componentId"
        :is="componentMap[component.type]"
        v-bind="component.props"
        @click="component.onClickId ? clickTriggered(component.onClickId) : null"
      >
      </component>
    </div>
  </div>
</template>