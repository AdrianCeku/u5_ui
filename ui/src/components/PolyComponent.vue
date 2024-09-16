<script setup lang="ts">
import Accordion from './wrappers/Accordion.vue'
import Alert from './wrappers/Alert.vue'
import AlertDialog from './wrappers/AlertDialog.vue'
import Input from './wrappers/Input.vue'

import type { Component } from '../App.vue'

interface ComponentMap {
  [key: string]: any;
}

const componentMap: ComponentMap = {
  "Accordion": Accordion,
  "Alert": Alert,
  "AlertDialog": AlertDialog,
  "Input": Input,
}

function getComponent(componentType: string) {
  return componentMap[componentType]
}

const props = defineProps<{
  component : Component
  sectionId: number
  componentId: number
}>()

function clickTriggered(onClickFunctionId: number, data: any, sectionId: number, componentId: number) {
  fetch(`https://u5_ui/clickTriggered`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        onClickFunctionId: onClickFunctionId,
        data: data,
        sectionId: sectionId,
        componentId: componentId
    })
  });
}

function inputTriggered(onInputFunctionId: number, value: any, sectionId: number, componentId: number) {
  fetch(`https://u5_ui/inputTriggered`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        onInputFunctionId: onInputFunctionId,
        value: value,
        sectionId: sectionId,
        componentId: componentId
    })
  });
}
</script>

<template>
  <component 
    v-if="!props.component.isDeleted"
    :is="getComponent(props.component.componentType)" 
    v-bind="props.component.props"
    :style="props.component.style"
    @event-click="(data: any) => props.component.onClickId && clickTriggered(props.component.onClickId, data, props.sectionId, props.componentId)"
    @event-input="(value: any) => props.component.onInputId && inputTriggered(props.component.onInputId, value, props.sectionId, props.componentId)"
  >
    <div :v-if="component.innerHTML" v-html="component.innerHTML"></div>
  </component>
</template>