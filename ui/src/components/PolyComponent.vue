<script setup lang="ts">
import Accordion from './wrappers/Accordion.vue'
import Alert from './wrappers/Alert.vue'
import AlertDialog from './wrappers/AlertDialog.vue'
import Input from './wrappers/Input.vue'

interface ComponentMap {
  [key: string]: any;
}

interface Component {    
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
  component : Component
}>()
</script>

<template>
    <component 
    v-if="!props.component.isDeleted"
    :is="getComponent(props.component.componentType)" 
    v-bind="props.component.props"
    @event-click="(data: any) => $emit('event-click', data)"
    @event-input="(value: any) => $emit('event-input', value)"
    >
        <div :v-if="component.innerHTML" v-html="component.innerHTML"></div>
    </component>
</template>