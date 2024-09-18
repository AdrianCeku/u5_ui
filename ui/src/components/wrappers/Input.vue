<script setup lang="ts">
import { Input } from "../ui/input"
import { ref } from "vue"

const props = defineProps<{
    type: "text" | "checkbox" | "color" | "date" | "datetime-local" | "number" | "password" | "range" | "time"
    label?: string
    placeholder?: string
}>()

let inputValue = ref<string | number | undefined>("")

function onFocus() {
    fetch(`https://u5_ui/focusInput`, {
    method: "POST",
    headers: {
        "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({
        inputValue: inputValue.value
    })
  });
}

function onFocusOut() {
    fetch(`https://u5_ui/focusOutInput`, {
    method: "POST",
    headers: {
        "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({
        inputValue: inputValue.value
    })
  });
}

interface Types {
    "text"?: string
    "checkbox"?: string
    "color"?: string
    "date"?: string
    "datetime-local"?: string
    "number"?: string
    "password"?: string
    "range"?: string
    "time"?: string
}

function getClasses() {
    const defaultClasses = "max-w-sm"
    const types: Types = {
        "checkbox": "w-4",
        "color" : "w-5 h-6 rounded-xl p-0 border-none rounded-2xl bg-transparent",
        "number" : "w-fit",
        "range" : "w-[min(100%,10rem)] p-0",
        "date": "w-fit pr-0",
        "datetime-local": "w-fit pr-0",
        "time": "w-fit pr-0",
    }

    return types[props.type] ?? defaultClasses
}

function getWrapperClasses() {
    const defaultClasses = "grid max-w-sm items-center gap-1.5"

    const types: Types= {
        "checkbox": "flex max-w-sm items-center gap-1.5",
        "color" : "flex max-w-sm items-center gap-1.5",
    }

    return types[props.type] ?? defaultClasses
}

function handleClick() {
    const el = document.querySelector('input')
    if(el) el.showPicker()
}

</script>

<template>
    <div :class="getWrapperClasses()">
        <Label
            for="input"
            v-if="props.label"
        > 
            {{ props.label }} 
            {{  inputValue }}
        </Label>
        <Input 
            v-model="inputValue"
            id="input"
            :type="props.type"
            @click="$emit('event-click', inputValue); handleClick()"
            @input="$emit('event-input', inputValue)"
            :placeholder="props.placeholder"
            @focus="onFocus()"
            @focusout="onFocusOut()"
            :class="getClasses()"
            class=""
        />
    </div>
</template>