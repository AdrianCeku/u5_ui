<script setup lang="ts">
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from '../ui/accordion'

const props = defineProps({
    headline: String,
    content: String
})
</script>

<template>
    <Accordion type="single" collapsible>
        <AccordionItem value="item-1">
            <AccordionTrigger @click="$emit('event-click')">{{ props.headline }}</AccordionTrigger>
            <AccordionContent>
                {{ props.content }}
                <slot />
            </AccordionContent>
        </AccordionItem>
    </Accordion>
</template>