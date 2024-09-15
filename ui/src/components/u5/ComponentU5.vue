<script setup lang="ts">
import Accordion from './Accordion.vue'
import Alert from './Alert.vue'
import AlertDialog from './AlertDialog.vue'
import Input from './Input.vue'

interface ComponentMap {
  [key: string]: any;
}

interface component {    
    isDeleted: boolean
    componentType: string
    props?: {
      [key: string]: any
    }
    innerHTML?: string
    onClickId?: number
    onInputId?: number
    style?: string[]
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
  component : component
}>()
</script>

<template>
    <component 
    v-if="!props.component.isDeleted"
    :is="getComponent(props.component.componentType)" 
    v-bind="props.component.props"
    @event-click="(passThrough: any) => $emit('event-click', passThrough)"
    @event-input="(value: any) => $emit('event-input', value)"
    >
        <div :v-if="component.innerHTML" v-html="component.innerHTML"></div>
    </component>
</template>