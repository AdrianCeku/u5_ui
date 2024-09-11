<script setup lang="ts">
import { ref } from 'vue';


const componentMap = {

}

const sections = ref([])

window.addEventListener('message', (event) => {
  console.log(event.data)
  if (event.data.type === 'addSection') {
    sections.value.push(event.data.section)
    console.log(sections.value)
  }
})

</script>

<template>
  <div>
    <div v-for="(section, index) in sections" :key="index">
      <h1>{{ section.options.title }}</h1>
      <component
        v-for="(comp, compIndex) in section.components"
        :key="compIndex"
        :is="componentMap[comp.type]"
        v-bind="comp.props"
      >
      {{ comp.props.text }}
      </component>
    </div>
  </div>
</template>