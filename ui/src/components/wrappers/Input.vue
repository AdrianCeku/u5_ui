<script setup lang="ts">
import { Input } from '../ui/input'
import { ref } from 'vue'

const props = defineProps<{
    label?: string
    type?: string
    placeholder?: string
}>()

let inputValue = ref<string | number | undefined>("")

</script>

<template>
    <div>
        <Label for="input" v-if="props.label"> {{ props.label }} </Label>
        <Input 
            v-model="inputValue"
            id="input"
            :type="props.type"
            @click="$emit('event-click', inputValue)"
            @input="$emit('event-input', inputValue)"
            :placeholder="props.placeholder"
        />
    </div>
</template>