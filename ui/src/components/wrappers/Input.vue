<script setup lang="ts">
import { Input } from "../ui/input"
import { ref } from "vue"

const props = defineProps<{
    label?: string
    type?: string
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
            @focus="onFocus()"
            @focusout="onFocusOut()"
        />
    </div>
</template>