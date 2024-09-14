<script setup lang="ts">
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from '../ui/accordion'

const props = defineProps({
    headline: String,
    content: String
})

let isOpen: boolean = true

function getState() {
    const retval = isOpen
    isOpen = !isOpen
    return retval
}
</script>

<template>
    <Accordion type="single" collapsible>
        <AccordionItem value="item-1">
            <AccordionTrigger @click="$emit('event-click', {value: getState()})">{{ props.headline }}</AccordionTrigger>
            <AccordionContent>
                {{ props.content }}
                <slot />
            </AccordionContent>
        </AccordionItem>
    </Accordion>
</template>